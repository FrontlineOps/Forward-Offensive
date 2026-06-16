/*
    Generates objective topology from world locations.

    FOOF should not require players or server operators to hand-edit
    objective definition files. This function turns map locations into
    named objectives linked to generated map grid cells.
*/

private _center = [worldSize / 2, worldSize / 2, 0];
private _locationTypes = [
    "NameCityCapital",
    "NameCity",
    "NameVillage",
    "NameLocal",
    "Airport",
    "Strategic"
];
private _locations = nearestLocations [_center, _locationTypes, worldSize];
private _candidates = [];

{
    private _name = text _x;

    if (_name isNotEqualTo "") then {
        private _type = type _x;
        private _priority = switch (_type) do {
            case "NameCityCapital": { 100 };
            case "Airport": { 90 };
            case "NameCity": { 80 };
            case "Strategic": { 70 };
            case "NameVillage": { 60 };
            case "NameLocal": { 45 };
            default { 10 };
        };

        _candidates pushBack [-_priority, _name, locationPosition _x, _type];
    };
} forEach _locations;

_candidates sort true;

private _definitions = [];
private _acceptedPositions = [];
private _usedIds = createHashMap;
private _claimedCellIds = createHashMap;
private _maxObjectives = FLO_ObjectiveGeneratedMaxObjectives;
private _minSpacing = FLO_ObjectiveGeneratedMinSpacing;
private _defaultObjectiveGridRadius = FLO_ObjectiveGeneratedObjectiveGridRadius;
private _requiredRatio = FLO_ObjectiveGeneratedRequiredWeightRatio;
private _index = 0;

{
    if ((count _definitions) >= _maxObjectives) exitWith {};

    _x params ["_sortPriority", "_name", "_rawPosition", "_type"];

    private _position = [_rawPosition # 0, _rawPosition # 1, 0];
    private _nearCount = {
        (_x distance2D _position) < _minSpacing
    } count _acceptedPositions;

    if (_nearCount isEqualTo 0) then {
        private _resourceWeight = switch (_type) do {
            case "NameCityCapital": { 5 };
            case "Airport": { 4 };
            case "NameCity": { 3 };
            case "Strategic": { 3 };
            case "NameVillage": { 2 };
            default { 1 };
        };
        private _objectiveGridRadius = switch (_type) do {
            case "NameCityCapital": { 1800 };
            case "Airport": { 1800 };
            case "NameCity": { 1400 };
            case "Strategic": { 1400 };
            case "NameVillage": { 1000 };
            default { _defaultObjectiveGridRadius };
        };
        private _anchorCell = [_position] call FLO_fnc_objectiveGridCellAtPosition;
        private _anchorCellId = _anchorCell get "id";

        if !(_anchorCellId in _claimedCellIds) then {
            private _fallbackId = format ["objective_%1", _index];
            private _id = [_name, _fallbackId] call FLO_fnc_objectiveSanitizeId;

            if (_id in (keys _usedIds)) then {
                _id = format ["%1_%2", _id, _index];
            };

            _usedIds set [_id, true];
            _acceptedPositions pushBack _position;
            _index = _index + 1;

            private _anchorX = _anchorCell get "gridX";
            private _anchorY = _anchorCell get "gridY";
            private _cellRange = ceil (_objectiveGridRadius / FLO_ObjectiveGridCellSize);
            private _minX = (_anchorX - _cellRange) max 0;
            private _maxX = (_anchorX + _cellRange) min (FLO_ObjectiveGridWidth - 1);
            private _minY = (_anchorY - _cellRange) max 0;
            private _maxY = (_anchorY + _cellRange) min (FLO_ObjectiveGridHeight - 1);
            private _cellIds = [];

            for "_xIndex" from _minX to _maxX do {
                for "_yIndex" from _minY to _maxY do {
                    private _cellId = [_xIndex, _yIndex] call FLO_fnc_objectiveGridCellId;

                    if ((_cellId in FLO_ObjectiveGridCellIdSet) && {!(_cellId in _claimedCellIds)}) then {
                        private _cell = FLO_ObjectiveCells get _cellId;

                        if (((_cell get "position") distance2D _position) <= _objectiveGridRadius) then {
                            _cellIds pushBack _cellId;
                        };
                    };
                };
            };

            if !(_anchorCellId in _cellIds) then {
                _cellIds pushBack _anchorCellId;
            };

            {
                _claimedCellIds set [_x, true];
            } forEach _cellIds;

            _definitions pushBack createHashMapFromArray [
                ["id", _id],
                ["name", _name],
                ["position", _position],
                ["locationType", _type],
                ["resourceWeight", _resourceWeight],
                ["requiredWeightRatio", _requiredRatio],
                ["anchorCellId", _anchorCellId],
                ["cellIds", _cellIds]
            ];
        };
    };
} forEach _candidates;

diag_log format [
    "[FLO][Objective] Generated %1 objectives from %2 world locations",
    count _definitions,
    count _candidates
];

_definitions
