params [["_objectiveIds", keys FLO_Objectives]];

private _objectiveIds = +_objectiveIds;
_objectiveIds sort true;

private _snapshot = [];

{
    private _objective = FLO_Objectives get _x;
    private _cellSnapshot = [];
    private _cellIds = +(_objective get "cellIds");
    private _anchorCellId = _objective get "anchorCellId";

    _cellIds sort true;

    {
        private _cell = FLO_ObjectiveCells get _x;
        private _progress = round ((_cell get "progress") * 20) / 20;
        private _role = ["support", "anchor"] select (_x isEqualTo _anchorCellId);

        _cellSnapshot pushBack [
            _cell get "id",
            _role,
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
        _cellSnapshot,
        _objective get "resourceWeight",
        _objective get "locationType",
        _objective get "displayRadius",
        _objective get "level",
        [_objective get "level"] call FLO_fnc_objectiveLevelName,
        [_objective] call FLO_fnc_objectiveIncomePer15,
        [_objective] call FLO_fnc_objectiveUpgradeCost,
        FLO_ObjectiveMaxLevel
    ];
} forEach _objectiveIds;

_snapshot
