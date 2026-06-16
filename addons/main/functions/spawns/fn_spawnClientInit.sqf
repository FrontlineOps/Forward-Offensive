if (!hasInterface) exitWith {};

[
    { !isNull player && {(side group player) in [west, east]} },
    {
        [player] remoteExecCall ["FLO_fnc_spawnRequestAssignment", 2];
    }
] call CBA_fnc_waitUntilAndExecute;

diag_log "[FLO][Spawn] Client spawn assignment request initialized";
