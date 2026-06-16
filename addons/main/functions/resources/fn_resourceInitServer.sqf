if (!isServer) exitWith {};

FLO_ResourceBalances = createHashMapFromArray [
    ["WEST", 0],
    ["EAST", 0]
];
FLO_ResourceIncome = createHashMapFromArray [
    ["WEST", 0],
    ["EAST", 0]
];
FLO_ResourceCellIncomeLast = createHashMapFromArray [
    ["WEST", 0],
    ["EAST", 0]
];
FLO_ResourceObjectiveIncomeLast = createHashMapFromArray [
    ["WEST", 0],
    ["EAST", 0]
];
FLO_ResourceEarnedTotal = createHashMapFromArray [
    ["WEST", 0],
    ["EAST", 0]
];
FLO_ResourceSpentTotal = createHashMapFromArray [
    ["WEST", 0],
    ["EAST", 0]
];
FLO_ResourceSnapshot = [];
FLO_ResourceTickCount = 0;
FLO_ResourceRevision = 0;
FLO_ResourceSystemRunning = false;
FLO_ResourceLoopHandle = -1;

FLO_ResourceTickInterval = 60;
FLO_ResourceCellIncome = 1;
FLO_ResourceObjectiveWeightIncome = 5;

private _income = [] call FLO_fnc_resourceCalculateIncome;
FLO_ResourceCellIncomeLast = _income get "cellIncome";
FLO_ResourceObjectiveIncomeLast = _income get "objectiveIncome";
FLO_ResourceIncome = _income get "totalIncome";

[0] call FLO_fnc_resourceSendSnapshot;
[] call FLO_fnc_resourceStartLoop;

diag_log format [
    "[FLO][Resource] Resource system initialized tickInterval=%1 cellIncome=%2 objectiveWeightIncome=%3",
    FLO_ResourceTickInterval,
    FLO_ResourceCellIncome,
    FLO_ResourceObjectiveWeightIncome
];
