params ["_unit", "_unitClass", ["_attempt", 0]];

if (!isServer) exitWith {};
if (isNull _unit) exitWith {};
if (!isPlayer _unit) exitWith {};
if (_unitClass isEqualTo "") exitWith {};
if !(isClass (configFile >> "CfgVehicles" >> _unitClass)) exitWith {};
if !(_unitClass isKindOf "CAManBase") exitWith {};

private _owner = owner _unit;

if (_owner > 2) exitWith {
    [_unit, _unitClass] remoteExecCall ["FLO_fnc_spawnApplyDefaultKit", _owner];
};

if (hasInterface && {player isEqualTo _unit}) exitWith {
    [_unit, _unitClass] call FLO_fnc_spawnApplyDefaultKit;
};

if (_attempt < 20) exitWith {
    [
        {
            params ["_unit", "_unitClass", "_attempt"];
            [_unit, _unitClass, _attempt + 1] call FLO_fnc_spawnSyncDefaultKit;
        },
        [_unit, _unitClass, _attempt],
        0.5
    ] call CBA_fnc_waitAndExecute;
};

diag_log format [
    "[FLO][Spawn] Could not sync default kit %1 to %2 owner=%3",
    _unitClass,
    _unit,
    _owner
];
