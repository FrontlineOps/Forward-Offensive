params [
    ["_unit", player, [objNull]],
    ["_unitClass", "", [""]]
];

if (!hasInterface) exitWith {};
if (isMultiplayer && {remoteExecutedOwner isNotEqualTo 2} && {remoteExecutedOwner isNotEqualTo 0}) exitWith {};
if (isNull _unit) exitWith {};
if (!local _unit) exitWith {};
if (_unitClass isEqualTo "") exitWith {};
if !(isClass (configFile >> "CfgVehicles" >> _unitClass)) exitWith {};
if !(_unitClass isKindOf "CAManBase") exitWith {};

private _loadout = getUnitLoadout (configFile >> "CfgVehicles" >> _unitClass);

if !(_loadout isEqualType []) exitWith {
    diag_log format ["[FLO][Spawn] Default kit %1 did not resolve to a loadout", _unitClass];
};

if ((count _loadout) < 10) exitWith {
    diag_log format ["[FLO][Spawn] Default kit %1 resolved to an incomplete loadout: %2", _unitClass, _loadout];
};

_unit setUnitLoadout _loadout;

diag_log format [
    "[FLO][Spawn] Applied default kit %1 to %2",
    _unitClass,
    name _unit
];
