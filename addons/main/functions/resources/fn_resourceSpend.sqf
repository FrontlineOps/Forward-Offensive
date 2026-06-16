params ["_side", "_amount", ["_reason", ""]];

if (!isServer) exitWith { false };

private _sideKey = [_side] call FLO_fnc_resourceSideKey;
private _amountInt = floor _amount;

if (_amountInt < 0) then {
    throw format ["[FLO][Resource] Cannot spend negative currency amount: %1", _amountInt];
};

private _balance = FLO_ResourceBalances get _sideKey;

if (_balance < _amountInt) exitWith { false };

FLO_ResourceBalances set [_sideKey, _balance - _amountInt];
FLO_ResourceSpentTotal set [_sideKey, (FLO_ResourceSpentTotal get _sideKey) + _amountInt];
FLO_ResourceRevision = FLO_ResourceRevision + 1;

if (_reason isNotEqualTo "") then {
    diag_log format [
        "[FLO][Resource] Spent %1 from %2 reason=%3 balance=%4",
        _amountInt,
        _sideKey,
        _reason,
        FLO_ResourceBalances get _sideKey
    ];
};

[] call FLO_fnc_resourceScheduleSnapshot;
["resourceSpend"] call FLO_fnc_persistenceScheduleSave;

true
