params ["_unitClass", "_factionClass", ["_allowFactionMismatch", false, [false]]];

private _unitCfg = configFile >> "CfgVehicles" >> _unitClass;

if !(isClass _unitCfg) exitWith { false };
if !(_unitClass isKindOf "CAManBase") exitWith { false };
if (!_allowFactionMismatch && {(toLower (getText (_unitCfg >> "faction"))) isNotEqualTo (toLower _factionClass)}) exitWith { false };

private _loadout = getUnitLoadout _unitCfg;

(_loadout isEqualType []) && {(count _loadout) >= 10}
