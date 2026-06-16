params ["_side", "_amount", ["_reason", ""]];

if (!isServer) exitWith {};

private _sideKey = [_side] call FLO_fnc_resourceSideKey;
private _amountInt = floor _amount;

if (_amountInt < 0) then {
    throw format ["[FLO][Resource] Cannot add negative currency amount: %1", _amountInt];
};

FLO_ResourceBalances set [_sideKey, (FLO_ResourceBalances get _sideKey) + _amountInt];
FLO_ResourceEarnedTotal set [_sideKey, (FLO_ResourceEarnedTotal get _sideKey) + _amountInt];
FLO_ResourceRevision = FLO_ResourceRevision + 1;

if (_reason isNotEqualTo "") then {
    diag_log format [
        "[FLO][Resource] Added %1 to %2 reason=%3 balance=%4",
        _amountInt,
        _sideKey,
        _reason,
        FLO_ResourceBalances get _sideKey
    ];
};

[0] call FLO_fnc_resourceSendSnapshot;
["resourceAdd"] call FLO_fnc_persistenceScheduleSave;
