params ["_side", "_amount", ["_reason", ""]];

if (!isServer) exitWith { 0 };

private _sideKey = [_side] call FLO_fnc_resourceSideKey;
private _amountInt = floor _amount;

if (_amountInt < 0) then {
    throw format ["[FLO][Objective] Cannot add negative free AO upgrade credits: %1", _amountInt];
};

if (_amountInt isEqualTo 0) exitWith { 0 };

private _newBalance = (FLO_ObjectiveFreeUpgradeCredits get _sideKey) + _amountInt;
FLO_ObjectiveFreeUpgradeCredits set [_sideKey, _newBalance];

diag_log format [
    "[FLO][Objective] Added %1 free AO upgrade credits to %2 reason=%3 balance=%4",
    _amountInt,
    _sideKey,
    _reason,
    _newBalance
];

[true] call FLO_fnc_objectivePublishSnapshot;
["objectiveFreeUpgradeCreditAdd"] call FLO_fnc_persistenceScheduleSave;

_amountInt
