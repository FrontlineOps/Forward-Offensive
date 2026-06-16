params ["_snapshot", ["_fullRefresh", true]];

if (!hasInterface) exitWith {};

private _activeMarkers = createHashMap;

{
    _x params [
        "_cellId",
        "_position",
        "_halfSize",
        "_ownerKey",
        "_state",
        "_progress",
        "_progressSideKey",
        "_influenceEast",
        "_influenceWest"
    ];

    private _baseMarkerId = format ["FLO_grid_%1_sector", _cellId];
    private _contestMarkerId = format ["FLO_grid_%1_contested", _cellId];
    private _captureMarkerId = format ["FLO_grid_%1_capture", _cellId];
    private _baseColor = [_ownerKey, _state, _progressSideKey] call FLO_fnc_objectiveMarkerColor;
    private _baseAlpha = switch (_state) do {
        case "held": { 0.36 };
        case "capturing": { 0.34 };
        case "contested": { 0.30 };
        default { 0.22 };
    };
    private _renderKey = str [_ownerKey, _state, _progress, _progressSideKey];
    private _needsStateUpdate = !(_cellId in FLO_ObjectiveClientGridMarkerKeys) ||
        {(FLO_ObjectiveClientGridMarkerKeys get _cellId) isNotEqualTo _renderKey};

    if (_needsStateUpdate) then {
        [
            _baseMarkerId,
            _position,
            "RECTANGLE",
            "",
            _baseColor,
            _baseAlpha,
            [_halfSize, _halfSize],
            "Solid",
            "",
            0,
            FLO_ObjectiveClientGridMarkers
        ] call FLO_fnc_objectiveUpsertMapMarker;
        FLO_ObjectiveClientGridMarkerKeys set [_cellId, _renderKey];
    };

    if (_fullRefresh) then {
        _activeMarkers set [_baseMarkerId, true];
    };

    if (_state isEqualTo "contested") then {
        if (_needsStateUpdate) then {
            [
                _contestMarkerId,
                _position,
                "RECTANGLE",
                "",
                "ColorYellow",
                0.62,
                [_halfSize, _halfSize],
                "DiagGrid",
                "",
                0,
                FLO_ObjectiveClientGridMarkers
            ] call FLO_fnc_objectiveUpsertMapMarker;
        };

        if (_fullRefresh) then {
            _activeMarkers set [_contestMarkerId, true];
        };
    } else {
        if (_contestMarkerId in FLO_ObjectiveClientGridMarkers) then {
            private _contestMarker = FLO_ObjectiveClientGridMarkers get _contestMarkerId;

            deleteMarkerLocal _contestMarker;
            FLO_ObjectiveClientGridMarkers deleteAt _contestMarkerId;
        };
    };

    if ((_state isEqualTo "capturing") && {_progress > 0}) then {
        if (_needsStateUpdate) then {
            private _captureColor = [_progressSideKey, "held", "NONE"] call FLO_fnc_objectiveMarkerColor;
            private _captureSize = _halfSize * (0.2 + (_progress * 0.8));

            [
                _captureMarkerId,
                _position,
                "RECTANGLE",
                "",
                _captureColor,
                0.58,
                [_captureSize, _captureSize],
                "DiagGrid",
                "",
                0,
                FLO_ObjectiveClientGridMarkers
            ] call FLO_fnc_objectiveUpsertMapMarker;
        };

        if (_fullRefresh) then {
            _activeMarkers set [_captureMarkerId, true];
        };
    } else {
        if (_captureMarkerId in FLO_ObjectiveClientGridMarkers) then {
            private _captureMarker = FLO_ObjectiveClientGridMarkers get _captureMarkerId;

            deleteMarkerLocal _captureMarker;
            FLO_ObjectiveClientGridMarkers deleteAt _captureMarkerId;
        };
    };

} forEach _snapshot;

if (_fullRefresh) then {
    {
        if (!(_x in _activeMarkers)) then {
            private _marker = FLO_ObjectiveClientGridMarkers get _x;

            deleteMarkerLocal _marker;
            FLO_ObjectiveClientGridMarkers deleteAt _x;
        };
    } forEach (keys FLO_ObjectiveClientGridMarkers);
};
