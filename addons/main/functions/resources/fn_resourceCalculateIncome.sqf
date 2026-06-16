private _cellIncome = createHashMapFromArray [
    ["WEST", 0],
    ["EAST", 0]
];
private _objectiveIncome = createHashMapFromArray [
    ["WEST", 0],
    ["EAST", 0]
];

{
    private _cell = FLO_ObjectiveCells get _x;
    private _owner = _cell get "owner";
    private _state = _cell get "state";

    if ((_owner in [west, east]) && {_state isEqualTo "held"}) then {
        private _sideKey = [_owner] call FLO_fnc_resourceSideKey;

        _cellIncome set [_sideKey, (_cellIncome get _sideKey) + FLO_ResourceCellIncome];
    };
} forEach FLO_ObjectiveGridCellIds;

{
    private _objective = FLO_Objectives get _x;
    private _owner = _objective get "owner";
    private _state = _objective get "state";

    if ((_owner in [west, east]) && {_state isEqualTo "held"}) then {
        private _sideKey = [_owner] call FLO_fnc_resourceSideKey;

        _objectiveIncome set [
            _sideKey,
            (_objectiveIncome get _sideKey) + ([_objective] call FLO_fnc_objectiveIncomePerTick)
        ];
    };
} forEach keys FLO_Objectives;

createHashMapFromArray [
    ["cellIncome", _cellIncome],
    ["objectiveIncome", _objectiveIncome],
    ["totalIncome", createHashMapFromArray [
        ["WEST", (_cellIncome get "WEST") + (_objectiveIncome get "WEST")],
        ["EAST", (_cellIncome get "EAST") + (_objectiveIncome get "EAST")]
    ]]
]
