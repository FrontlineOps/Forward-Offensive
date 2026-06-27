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
        "_locationType",
        "_displayRadius",
        "_level",
        "_levelName",
        "_incomePer10",
        "_upgradeCost",
        "_maxLevel"
    ];

    private _objectiveMarkerId = format ["FLO_obj_%1_icon", _objectiveId];
    private _haloMarkerId = format ["FLO_obj_%1_halo", _objectiveId];
    private _resourceMarkerId = format ["FLO_obj_%1_resource", _objectiveId];
    private _objectiveColor = [_ownerKey, _objectiveState, "NONE"] call FLO_fnc_objectiveMarkerColor;
    private _objectiveText = format ["L%1", _level];

    private _markerType = switch (_locationType) do {
        case "Airport": { "mil_triangle" };
        case "Strategic": { "mil_box" };
        default { "mil_dot" };
    };
    private _iconAlpha = switch (_objectiveState) do {
        case "capturing": { 0.78 };
        case "held": { 0.64 };
        default { 0.50 };
    };
    private _markerSize = switch (_resourceWeight) do {
        case 5: { [0.40, 0.40] };
        case 4: { [0.36, 0.36] };
        case 3: { [0.32, 0.32] };
        default { [0.24, 0.24] };
    };
    private _haloAlpha = switch (_objectiveState) do {
        case "capturing": { 0.30 };
        case "held": { 0.16 };
        default { 0.12 };
    };
    private _haloBrush = ["Border", "DiagGrid"] select (_objectiveState isEqualTo "capturing");

    [
        _haloMarkerId,
        _position,
        "ELLIPSE",
        "",
        _objectiveColor,
        _haloAlpha,
        [_displayRadius, _displayRadius],
        _haloBrush,
        "",
        0,
        FLO_ObjectiveClientMarkers
    ] call FLO_fnc_objectiveUpsertMapMarker;
    _activeMarkers set [_haloMarkerId, true];

    if (_resourceMarkerId in FLO_ObjectiveClientMarkers) then {
        private _resourceMarker = FLO_ObjectiveClientMarkers get _resourceMarkerId;

        deleteMarkerLocal _resourceMarker;
        FLO_ObjectiveClientMarkers deleteAt _resourceMarkerId;
    };

    [
        _objectiveMarkerId,
        _position,
        "ICON",
        _markerType,
        _objectiveColor,
        _iconAlpha,
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
