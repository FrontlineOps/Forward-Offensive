params ["_presence"];

{
    private _cell = FLO_ObjectiveCells get _x;

    _cell set ["influenceEast", 0];
    _cell set ["influenceWest", 0];
} forEach FLO_ObjectivePresenceCellIds;

private _touchedCellIds = createHashMap;

{
    _x params ["_side", "_position"];

    private _cellId = [_position] call FLO_fnc_objectiveGridCellIdAtPosition;

    if (_cellId in FLO_ObjectiveGridCellIdSet) then {
        private _cell = FLO_ObjectiveCells get _cellId;

        if (_side isEqualTo east) then {
            _cell set ["influenceEast", (_cell get "influenceEast") + 1];
        };

        if (_side isEqualTo west) then {
            _cell set ["influenceWest", (_cell get "influenceWest") + 1];
        };

        _touchedCellIds set [_cellId, true];
    };
} forEach _presence;

FLO_ObjectivePresenceCellIds = keys _touchedCellIds;
