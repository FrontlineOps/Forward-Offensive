params ["_snapshot", ["_fullRefresh", true]];

if (!hasInterface) exitWith {};

private _activeMarkers = createHashMap;

{
    _x params [
        "_objectiveId",
        "_name",
        "_position",
        "_ownerKey",
        "_objectiveState",
        "_eastWeight",
        "_westWeight",
        "_totalWeight",
        "_cells",
        "_resourceWeight",
        "_locationType"
    ];

    private _objectiveMarkerId = format ["FLO_obj_%1_icon", _objectiveId];
    private _valueMarkerId = format ["FLO_obj_%1_value", _objectiveId];
    private _objectiveColor = [_ownerKey, _objectiveState, "NONE"] call FLO_fnc_objectiveMarkerColor;
    private _objectiveText = switch (_objectiveState) do {
        case "contested": { format ["AO %1", toUpper _name] };
        case "capturing": { format ["AO %1", toUpper _name] };
        default { "" };
    };

    private _markerType = switch (_locationType) do {
        case "Airport": { "mil_triangle" };
        case "Strategic": { "mil_box" };
        default { "mil_dot" };
    };
    private _markerSize = switch (_resourceWeight) do {
        case 5: { [0.40, 0.40] };
        case 4: { [0.36, 0.36] };
        default { [0.28, 0.28] };
    };
    private _valueHaloSize = switch (_resourceWeight) do {
        case 5: { [220, 220] };
        case 4: { [170, 170] };
        default { [0, 0] };
    };

    if ((_resourceWeight >= 4) || {_objectiveState in ["contested", "capturing"]}) then {
        private _haloSize = _valueHaloSize;

        if (_resourceWeight < 4) then {
            _haloSize = [130, 130];
        };

        [
            _valueMarkerId,
            _position,
            "ELLIPSE",
            "",
            _objectiveColor,
            [0.20, 0.36] select (_objectiveState in ["contested", "capturing"]),
            _haloSize,
            ["Border", "DiagGrid"] select (_objectiveState in ["contested", "capturing"]),
            "",
            0,
            FLO_ObjectiveClientMarkers
        ] call FLO_fnc_objectiveUpsertMapMarker;
        _activeMarkers set [_valueMarkerId, true];
    } else {
        if (_valueMarkerId in FLO_ObjectiveClientMarkers) then {
            private _valueMarker = FLO_ObjectiveClientMarkers get _valueMarkerId;

            deleteMarkerLocal _valueMarker;
            FLO_ObjectiveClientMarkers deleteAt _valueMarkerId;
        };
    };

    [
        _objectiveMarkerId,
        _position,
        "ICON",
        _markerType,
        _objectiveColor,
        0.45,
        _markerSize,
        "",
        _objectiveText
    ] call FLO_fnc_objectiveUpsertMapMarker;
    _activeMarkers set [_objectiveMarkerId, true];
} forEach _snapshot;

if (_fullRefresh) then {
    {
        if (!(_x in _activeMarkers)) then {
            private _marker = FLO_ObjectiveClientMarkers get _x;

            deleteMarkerLocal _marker;
            FLO_ObjectiveClientMarkers deleteAt _x;
        };
    } forEach (keys FLO_ObjectiveClientMarkers);
};
