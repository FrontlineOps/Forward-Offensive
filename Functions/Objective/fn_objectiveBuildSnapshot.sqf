private _objectiveIds = keys FLO_Objectives;
_objectiveIds sort true;

private _snapshot = [];

{
    private _objective = FLO_Objectives get _x;
    private _cellSnapshot = [];
    private _cellIds = +(_objective get "cellIds");

    _cellIds sort true;

    {
        private _cell = FLO_ObjectiveCells get _x;
        private _progress = round ((_cell get "progress") * 20) / 20;

        _cellSnapshot pushBack [
            _cell get "id",
            _cell get "role",
            _cell get "position",
            _cell get "radius",
            [_cell get "owner"] call FLO_fnc_objectiveSideKey,
            _cell get "state",
            _progress,
            [_cell get "progressSide"] call FLO_fnc_objectiveSideKey,
            _cell get "influenceEast",
            _cell get "influenceWest"
        ];
    } forEach _cellIds;

    _snapshot pushBack [
        _objective get "id",
        _objective get "name",
        _objective get "position",
        [_objective get "owner"] call FLO_fnc_objectiveSideKey,
        _objective get "state",
        _objective get "eastWeight",
        _objective get "westWeight",
        _objective get "totalWeight",
        _cellSnapshot
    ];
} forEach _objectiveIds;

_snapshot
