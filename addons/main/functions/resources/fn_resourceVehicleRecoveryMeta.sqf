params [["_className", "", [""]]];

if (_className in FLO_ResourceVehicleRecoveryMetaCache) exitWith {
    FLO_ResourceVehicleRecoveryMetaCache get _className
};

private _sideKey = [_className] call FLO_fnc_resourceVehicleConfigSideKey;
private _category = "";
private _price = 0;

if (_sideKey in ["WEST", "EAST"]) then {
    _category = [_className] call FLO_fnc_storeCategoryForVehicle;

    if (_category in ["cars", "armor", "helis", "planes", "naval", "static"]) then {
        _price = [_className, _category] call FLO_fnc_storePriceVehicle;
    };
};

private _meta = [_sideKey, _category, _price];
FLO_ResourceVehicleRecoveryMetaCache set [_className, _meta];

_meta
