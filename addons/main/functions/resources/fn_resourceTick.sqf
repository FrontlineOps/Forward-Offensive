if (!isServer) exitWith {};

private _income = [] call FLO_fnc_resourceCalculateIncome;
private _cellIncome = _income get "cellIncome";
private _objectiveIncome = _income get "objectiveIncome";
private _totalIncome = _income get "totalIncome";

FLO_ResourceCellIncomeLast = _cellIncome;
FLO_ResourceObjectiveIncomeLast = _objectiveIncome;
FLO_ResourceIncome = _totalIncome;

{
    private _gain = _totalIncome get _x;

    FLO_ResourceBalances set [_x, (FLO_ResourceBalances get _x) + _gain];
    FLO_ResourceEarnedTotal set [_x, (FLO_ResourceEarnedTotal get _x) + _gain];
} forEach ["WEST", "EAST"];

FLO_ResourceTickCount = FLO_ResourceTickCount + 1;
FLO_ResourceRevision = FLO_ResourceRevision + 1;

diag_log format [
    "[FLO][Resource] Tick %1 BLUFOR +%2 balance=%3 OPFOR +%4 balance=%5",
    FLO_ResourceTickCount,
    _totalIncome get "WEST",
    FLO_ResourceBalances get "WEST",
    _totalIncome get "EAST",
    FLO_ResourceBalances get "EAST"
];

[] call FLO_fnc_resourceScheduleSnapshot;
["resourceTick"] call FLO_fnc_persistenceScheduleSave;
