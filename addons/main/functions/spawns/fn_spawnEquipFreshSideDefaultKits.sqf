params ["_side"];

if (!isServer) exitWith {};
if !(_side in [west, east]) exitWith {};

private _sideKey = [_side] call FLO_fnc_resourceSideKey;
private _defaultKitClass = [_sideKey] call FLO_fnc_spawnSideDefaultKitClass;

if (_defaultKitClass isEqualTo "") exitWith {};

private _equipped = 0;

{
    if ((side group _x) isNotEqualTo _side) then { continue };
    if (_x getVariable ["FLO_Persistence_Loaded", false]) then { continue };

    [_x, _defaultKitClass] call FLO_fnc_spawnSyncDefaultKit;
    _equipped = _equipped + 1;
} forEach allPlayers;

diag_log format [
    "[FLO][Spawn] Equipped %1 fresh %2 players with default kit %3",
    _equipped,
    _sideKey,
    _defaultKitClass
];
