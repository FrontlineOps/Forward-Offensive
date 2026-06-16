if (!isServer) exitWith {};

{
    [_x] call FLO_fnc_spawnEnsureSideRespawn;
} forEach [west, east];
