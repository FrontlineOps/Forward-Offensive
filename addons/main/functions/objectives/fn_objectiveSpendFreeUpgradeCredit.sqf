params ["_side", ["_reason", ""]];

if (!isServer) exitWith { false };

private _sideKey = [_side] call FLO_fnc_resourceSideKey;
private _balance = FLO_ObjectiveFreeUpgradeCredits get _sideKey;

if (_balance <= 0) exitWith { false };

private _newBalance = _balance - 1;
FLO_ObjectiveFreeUpgradeCredits set [_sideKey, _newBalance];

diag_log format [
    "[FLO][Objective] Spent free AO upgrade credit from %1 reason=%2 balance=%3",
    _sideKey,
    _reason,
    _newBalance
];

["objectiveFreeUpgradeCreditSpend"] call FLO_fnc_persistenceScheduleSave;

true
