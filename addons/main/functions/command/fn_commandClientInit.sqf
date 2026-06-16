if (!hasInterface) exitWith {};

[
    { [] call FLO_fnc_commandCanOpenVoteDialog },
    {
        [player] remoteExecCall ["FLO_fnc_commandRequestSnapshot", 2];

        FLO_CommandClientSnapshotRetryHandle = [
            {
                if ([] call FLO_fnc_commandClientNeedsSnapshot) then {
                    [player] remoteExecCall ["FLO_fnc_commandRequestSnapshot", 2];
                } else {
                    [FLO_CommandClientSnapshotRetryHandle] call CBA_fnc_removePerFrameHandler;
                    FLO_CommandClientSnapshotRetryHandle = -1;
                };
            },
            2,
            []
        ] call CBA_fnc_addPerFrameHandler;

        diag_log "[FLO][Command] Client command voting initialized";
    }
] call CBA_fnc_waitUntilAndExecute;
