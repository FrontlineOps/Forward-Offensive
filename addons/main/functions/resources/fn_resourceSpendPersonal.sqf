params ["_sideOrKey", "_uid", "_amount", ["_reason", ""]];

if (!isServer) exitWith { false };

private _amountInt = floor _amount;

if (_amountInt < 0) then {
    throw format ["[FLO][Resource] Cannot spend negative personal currency amount: %1", _amountInt];
};

if (_amountInt isEqualTo 0) exitWith { true };

private _key = [_sideOrKey, _uid] call FLO_fnc_resourcePersonalKey;
private _balance = [_sideOrKey, _uid] call FLO_fnc_resourcePersonalBalance;

if (_balance < _amountInt) exitWith { false };

FLO_ResourcePersonalBalances set [_key, _balance - _amountInt];
FLO_ResourceRevision = FLO_ResourceRevision + 1;

if (_reason isNotEqualTo "") then {
    diag_log format [
        "[FLO][Resource] Spent personal %1 from %2 reason=%3 balance=%4",
        _amountInt,
        _key,
        _reason,
        FLO_ResourcePersonalBalances get _key
    ];
};

[] call FLO_fnc_resourceScheduleSnapshot;
["resourceSpendPersonal"] call FLO_fnc_persistenceScheduleSave;

true
