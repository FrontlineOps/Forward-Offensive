params ["_uid", "_amount"];

if (!isServer) exitWith { 0 };
if (_uid isEqualTo "") exitWith { 0 };

private _amountInt = floor _amount;

if (_amountInt < 0) then {
    throw format ["[FLO][Store] Cannot spend negative deployment fund amount: %1", _amountInt];
};

if (_amountInt isEqualTo 0) exitWith { 0 };

private _balance = [_uid] call FLO_fnc_storeDeploymentFundBalance;
private _spent = _balance min _amountInt;

if (_spent > 0) then {
    FLO_StoreDeploymentFunds set [_uid, _balance - _spent];
};

_spent
