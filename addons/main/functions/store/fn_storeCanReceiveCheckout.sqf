params ["_cart"];

private _response = {
    params ["_success", "_message"];

    createHashMapFromArray [
        ["success", _success],
        ["message", _message]
    ]
};

if (!hasInterface) exitWith {
    [true, ""] call _response
};

if ((typeName _cart) isNotEqualTo "ARRAY") exitWith {
    [false, "Invalid checkout cart."] call _response
};

private _freeByContainer = createHashMapFromArray [
    ["uniform", 0],
    ["vest", 0],
    ["backpack", 0]
];

private _fnc_itemMass = {
    params ["_className"];

    private _mass = 0;

    if (isClass (configFile >> "CfgMagazines" >> _className)) then {
        _mass = getNumber (configFile >> "CfgMagazines" >> _className >> "mass");
    } else {
        if (isClass (configFile >> "CfgWeapons" >> _className)) then {
            private _cfg = configFile >> "CfgWeapons" >> _className;
            _mass = getNumber (_cfg >> "ItemInfo" >> "mass");

            if (_mass <= 0) then {
                _mass = getNumber (_cfg >> "WeaponSlotsInfo" >> "mass");
            };
        };
    };

    _mass max 0
};

private _fnc_containerLoadForGear = {
    params ["_className", "_category"];

    if (_category isEqualTo "backpacks") exitWith {
        getNumber (configFile >> "CfgVehicles" >> _className >> "maximumLoad")
    };

    private _cfg = configFile >> "CfgWeapons" >> _className;
    private _containerClass = getText (_cfg >> "ItemInfo" >> "containerClass");

    if (_containerClass isEqualTo "") exitWith { 0 };

    getNumber (configFile >> "CfgVehicles" >> _containerClass >> "maximumLoad")
};

private _fnc_currentFreeLoad = {
    params ["_container", "_className", "_category"];

    if (_className isEqualTo "") exitWith { 0 };

    private _maxLoad = [_className, _category] call _fnc_containerLoadForGear;
    private _usedLoad = if (isNull _container) then { 0 } else { loadAbs _container };

    (_maxLoad - _usedLoad) max 0
};

private _fnc_needsCargoSpace = {
    params ["_className", "_category", "_slot"];

    if (_category in ["primary", "handgun", "secondary", "uniforms", "vests", "backpacks", "headgear", "facewear"]) exitWith { false };

    if (_category in ["ammo", "mines"]) exitWith { true };

    if (_category isEqualTo "attachments") exitWith {
        !(_slot in ["primary", "handgun", "secondary"])
    };

    if (_category isEqualTo "misc") exitWith {
        private _itemType = _className call BIS_fnc_itemType;
        private _group = _itemType param [0, ""];
        private _kind = _itemType param [1, ""];

        !(
            (_slot isEqualTo "assigned") ||
            {_slot isEqualTo "binocular"} ||
            {_kind in ["GPS", "Map", "Compass", "Watch", "Radio", "NVGoggles", "Terminal"]} ||
            {(_group isEqualTo "Weapon") && {_kind in ["Binocular", "LaserDesignator"]}}
        )
    };

    if (isClass (configFile >> "CfgMagazines" >> _className)) exitWith { true };

    if (isClass (configFile >> "CfgWeapons" >> _className)) exitWith {
        private _weaponCategory = [_className] call FLO_fnc_storeCategoryForWeapon;

        if (_weaponCategory isEqualTo "") exitWith { false };

        [_className, _weaponCategory, _slot] call _fnc_needsCargoSpace
    };

    false
};

private _fnc_consumeAutoLoad = {
    params ["_needed"];

    private _remaining = _needed;

    {
        if (_remaining <= 0) then { continue };

        private _free = _freeByContainer get _x;
        private _used = _free min _remaining;
        _freeByContainer set [_x, _free - _used];
        _remaining = _remaining - _used;
    } forEach ["uniform", "vest", "backpack"];

    _remaining <= 0
};

_freeByContainer set ["uniform", [uniformContainer player, uniform player, "uniforms"] call _fnc_currentFreeLoad];
_freeByContainer set ["vest", [vestContainer player, vest player, "vests"] call _fnc_currentFreeLoad];
_freeByContainer set ["backpack", [backpackContainer player, backpack player, "backpacks"] call _fnc_currentFreeLoad];

{
    if ((typeName _x) isNotEqualTo "HASHMAP") then { continue };

    private _entryKind = _x getOrDefault ["entryKind", ""];
    private _category = _x getOrDefault ["category", ""];
    private _className = [_x getOrDefault ["className", ""]] call FLO_fnc_storeNormalizeRuntimeClass;

    if (_entryKind isNotEqualTo "gear") then { continue };

    switch (_category) do {
        case "uniforms": {
            _freeByContainer set ["uniform", [_className, _category] call _fnc_containerLoadForGear];
        };
        case "vests": {
            _freeByContainer set ["vest", [_className, _category] call _fnc_containerLoadForGear];
        };
        case "backpacks": {
            _freeByContainer set ["backpack", [_className, _category] call _fnc_containerLoadForGear];
        };
    };
} forEach _cart;

private _ok = true;
private _message = "";

{
    if (!_ok) then { continue };
    if ((typeName _x) isNotEqualTo "HASHMAP") then { continue };

    private _entryKind = _x getOrDefault ["entryKind", ""];
    private _category = _x getOrDefault ["category", ""];
    private _className = [_x getOrDefault ["className", ""]] call FLO_fnc_storeNormalizeRuntimeClass;
    private _slot = _x getOrDefault ["slot", ""];
    private _quantity = floor (_x getOrDefault ["quantity", 1]);
    private _container = _x getOrDefault ["container", "auto"];
    private _name = _x getOrDefault ["name", _className];

    if (_entryKind isNotEqualTo "gear") then { continue };
    if (_quantity < 1) then { continue };
    if !(_container in FLO_StoreGearContainers) then {
        _container = "auto";
    };

    if !([_className, _category, _slot] call _fnc_needsCargoSpace) then { continue };

    private _needed = ([_className] call _fnc_itemMass) * _quantity;
    private _fits = if (_container isEqualTo "auto") then {
        [_needed] call _fnc_consumeAutoLoad
    } else {
        private _free = _freeByContainer get _container;

        if (_needed <= _free) then {
            _freeByContainer set [_container, _free - _needed];
            true
        } else {
            false
        }
    };

    if (!_fits) then {
        _ok = false;
        _message = format ["Not enough inventory space for %1. Clear room or target another container.", _name];
    };
} forEach _cart;

[_ok, _message] call _response
