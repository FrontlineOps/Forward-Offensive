params ["_sideOrKey", "_uid"];

if (_uid isEqualTo "") exitWith { 0 };

private _key = [_sideOrKey, _uid] call FLO_fnc_resourcePersonalKey;

if (_key in FLO_ResourcePersonalBalances) exitWith {
    FLO_ResourcePersonalBalances get _key
};

0
