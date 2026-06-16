if (!hasInterface) exitWith {};

[
    { [] call FLO_fnc_spawnClientReady },
    {
        [player] remoteExecCall ["FLO_fnc_spawnRequestAssignment", 2];

        FLO_SpawnClientAssignmentRetryHandle = [
            {
                if ([] call FLO_fnc_spawnClientNeedsAssignment) then {
                    [player] remoteExecCall ["FLO_fnc_spawnRequestAssignment", 2];
                } else {
                    [FLO_SpawnClientAssignmentRetryHandle] call CBA_fnc_removePerFrameHandler;
                    FLO_SpawnClientAssignmentRetryHandle = -1;
                };
            },
            2,
            []
        ] call CBA_fnc_addPerFrameHandler;
    }
] call CBA_fnc_waitUntilAndExecute;

diag_log "[FLO][Spawn] Client spawn assignment request initialized";
