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
    private _factionGain = round (_gain * FLO_ResourceFactionIncomeShare);
    private _personalGain = round (_gain * FLO_ResourcePersonalIncomeShare);
    private _side = [west, east] select (_x isEqualTo "EAST");
    private _personalRecipients = createHashMap;

    FLO_ResourceBalances set [_x, (FLO_ResourceBalances get _x) + _factionGain];
    FLO_ResourceEarnedTotal set [_x, (FLO_ResourceEarnedTotal get _x) + _factionGain];

    if (_personalGain > 0) then {
        {
            if ((side group _x) isEqualTo _side) then {
                private _uid = getPlayerUID _x;

                if ((_uid isNotEqualTo "") && {!(_uid in _personalRecipients)}) then {
                    private _personalKey = [_side, _uid] call FLO_fnc_resourcePersonalKey;
                    private _personalBalance = [_side, _uid] call FLO_fnc_resourcePersonalBalance;

                    _personalRecipients set [_uid, true];
                    FLO_ResourcePersonalBalances set [_personalKey, _personalBalance + _personalGain];
                };
            };
        } forEach allPlayers;
    };
} forEach ["WEST", "EAST"];

FLO_ResourceTickCount = FLO_ResourceTickCount + 1;
FLO_ResourceRevision = FLO_ResourceRevision + 1;

diag_log format [
    "[FLO][Resource] Tick %1 BLUFOR gross=%2 faction+%3 personalEach+%4 balance=%5 OPFOR gross=%6 faction+%7 personalEach+%8 balance=%9",
    FLO_ResourceTickCount,
    _totalIncome get "WEST",
    round ((_totalIncome get "WEST") * FLO_ResourceFactionIncomeShare),
    round ((_totalIncome get "WEST") * FLO_ResourcePersonalIncomeShare),
    FLO_ResourceBalances get "WEST",
    _totalIncome get "EAST",
    round ((_totalIncome get "EAST") * FLO_ResourceFactionIncomeShare),
    round ((_totalIncome get "EAST") * FLO_ResourcePersonalIncomeShare),
    FLO_ResourceBalances get "EAST"
];

[] call FLO_fnc_resourceScheduleSnapshot;
["resourceTick"] call FLO_fnc_persistenceScheduleSave;
