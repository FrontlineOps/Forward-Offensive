/*
    Generates objective topology from world locations.

    FOOF should not require players or server operators to hand-edit
    objective definition files. This function turns map locations into
    named objectives with generated anchor/support cells.
*/

private _center = [worldSize / 2, worldSize / 2, 0];
private _locationTypes = ["NameCityCapital", "NameCity", "NameVillage", "Airport"];
private _locations = nearestLocations [_center, _locationTypes, worldSize];
private _candidates = [];

{
    private _name = text _x;

    if !(_name isEqualTo "") then {
        private _type = type _x;
        private _priority = switch (_type) do {
            case "NameCityCapital": { 100 };
            case "Airport": { 90 };
            case "NameCity": { 80 };
            case "NameVillage": { 60 };
            default { 10 };
        };

        _candidates pushBack [-_priority, _name, locationPosition _x, _type];
    };
} forEach _locations;

_candidates sort true;

private _definitions = [];
private _acceptedPositions = [];
private _usedIds = createHashMap;
private _maxObjectives = FLO_ObjectiveGeneratedMaxObjectives;
private _minSpacing = FLO_ObjectiveGeneratedMinSpacing;
private _supportOffset = FLO_ObjectiveGeneratedSupportOffset;
private _anchorRadius = FLO_ObjectiveGeneratedAnchorRadius;
private _supportRadius = FLO_ObjectiveGeneratedSupportRadius;
private _supportWeight = FLO_ObjectiveGeneratedSupportWeight;
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
        private _fallbackId = format ["objective_%1", _index];
        private _id = [_name, _fallbackId] call FLO_fnc_objectiveSanitizeId;

        if (_id in (keys _usedIds)) then {
            _id = format ["%1_%2", _id, _index];
        };

        _usedIds set [_id, true];
        _acceptedPositions pushBack _position;
        _index = _index + 1;

        private _xPos = _position # 0;
        private _yPos = _position # 1;

        _definitions pushBack createHashMapFromArray [
            ["id", _id],
            ["name", _name],
            ["position", _position],
            ["locationType", _type],
            ["requiredWeightRatio", _requiredRatio],
            ["cells", [
                createHashMapFromArray [["id", format ["%1_anchor", _id]], ["role", "anchor"], ["position", _position], ["radius", _anchorRadius], ["weight", 1]],
                createHashMapFromArray [["id", format ["%1_north", _id]], ["role", "support"], ["position", [_xPos, _yPos + _supportOffset, 0]], ["radius", _supportRadius], ["weight", _supportWeight]],
                createHashMapFromArray [["id", format ["%1_south", _id]], ["role", "support"], ["position", [_xPos, _yPos - _supportOffset, 0]], ["radius", _supportRadius], ["weight", _supportWeight]],
                createHashMapFromArray [["id", format ["%1_east", _id]], ["role", "support"], ["position", [_xPos + _supportOffset, _yPos, 0]], ["radius", _supportRadius], ["weight", _supportWeight]],
                createHashMapFromArray [["id", format ["%1_west", _id]], ["role", "support"], ["position", [_xPos - _supportOffset, _yPos, 0]], ["radius", _supportRadius], ["weight", _supportWeight]]
            ]]
        ];
    };
} forEach _candidates;

diag_log format [
    "[FLO][Objective] Generated %1 objectives from %2 world locations",
    count _definitions,
    count _candidates
];

_definitions
