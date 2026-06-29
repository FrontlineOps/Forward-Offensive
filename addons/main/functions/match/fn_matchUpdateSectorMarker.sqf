params ["_snapshot"];

if (!hasInterface) exitWith {};

private _phase = _snapshot get "phase";
private _objectiveId = "";
private _position = [0, 0, 0];
private _radius = 0;

if (_phase isEqualTo "frontline") then {
    _objectiveId = _snapshot get "plannedObjectiveId";
    _position = _snapshot get "plannedSectorPosition";
    _radius = _snapshot get "plannedSectorRadius";
};

if (_phase isEqualTo "operation") then {
    _objectiveId = _snapshot get "operationObjectiveId";
    _position = _snapshot get "operationSectorPosition";
    _radius = _snapshot get "operationSectorRadius";
};

private _validObjective = (_objectiveId isEqualType "") && {_objectiveId isNotEqualTo ""};
private _validPosition = (_position isEqualType []) && {(count _position) >= 3};
private _validRadius = (_radius isEqualType 0) && {_radius > 0};

if (!_validObjective || {!_validPosition} || {!_validRadius}) exitWith {
    if (FLO_MatchObjectiveSectorMarkerId in FLO_MatchClientMarkers) then {
        deleteMarkerLocal (FLO_MatchClientMarkers get FLO_MatchObjectiveSectorMarkerId);
        FLO_MatchClientMarkers deleteAt FLO_MatchObjectiveSectorMarkerId;
    };

    if (_validObjective && {!_validPosition || {!_validRadius}}) then {
        private _rejectKey = format ["%1:%2:%3:%4", _phase, _objectiveId, _position, _radius];

        if (FLO_MatchLastSectorMarkerRejectKey isNotEqualTo _rejectKey) then {
            FLO_MatchLastSectorMarkerRejectKey = _rejectKey;
            diag_log format [
                "[FLO][Match] Skipped invalid operation sector marker phase=%1 objective=%2 position=%3 radius=%4",
                _phase,
                _objectiveId,
                _position,
                _radius
            ];
        };
    };
};

[
    FLO_MatchObjectiveSectorMarkerId,
    _position,
    "ELLIPSE",
    "",
    "ColorYellow",
    1,
    [_radius, _radius],
    "Border",
    "",
    0,
    FLO_MatchClientMarkers
] call FLO_fnc_objectiveUpsertMapMarker;
