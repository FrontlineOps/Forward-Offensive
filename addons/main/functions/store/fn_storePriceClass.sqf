params ["_className", "_category", "_entryKind"];

private _base = switch (_category) do {
    case "primary": { 250 };
    case "handgun": { 80 };
    case "secondary": { 650 };
    case "uniforms": { 40 };
    case "vests": { 120 };
    case "headgear": { 40 };
    case "facewear": { 20 };
    case "backpacks": { 80 };
    case "attachments": { 75 };
    case "ammo": { 10 };
    case "misc": { 25 };
    case "cars": { 800 };
    case "armor": { 3500 };
    case "helis": { 4500 };
    case "planes": { 8000 };
    case "naval": { 1200 };
    case "static": { 700 };
    default { 1000 };
};

if (_entryKind isEqualTo "vehicle") exitWith {
    private _cfg = configFile >> "CfgVehicles" >> _className;
    private _configCost = getNumber (_cfg >> "cost");
    private _derived = ceil (_configCost / 20);

    _base max _derived
};

private _mass = 0;

if (isClass (configFile >> "CfgWeapons" >> _className)) then {
    private _cfg = configFile >> "CfgWeapons" >> _className;
    _mass = getNumber (_cfg >> "ItemInfo" >> "mass");

    if (_mass <= 0) then {
        _mass = getNumber (_cfg >> "WeaponSlotsInfo" >> "mass");
    };
};

if (isClass (configFile >> "CfgMagazines" >> _className)) then {
    private _cfg = configFile >> "CfgMagazines" >> _className;
    _mass = getNumber (_cfg >> "mass");
};

if (isClass (configFile >> "CfgVehicles" >> _className)) then {
    private _cfg = configFile >> "CfgVehicles" >> _className;
    _mass = getNumber (_cfg >> "maximumLoad");
};

private _price = _base + (ceil (_mass / 6));

5 max ((ceil (_price / 5)) * 5)
