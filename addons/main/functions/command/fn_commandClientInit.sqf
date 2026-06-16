if (!hasInterface) exitWith {};

[
    { !isNull player && {(side group player) in [west, east]} },
    {
        [player] remoteExecCall ["FLO_fnc_commandRequestSnapshot", 2];

        [
            {
                if !("sideKey" in FLO_CommandSnapshot) then {
                    [player] remoteExecCall ["FLO_fnc_commandRequestSnapshot", 2];
                };
            },
            [],
            1
        ] call CBA_fnc_waitAndExecute;

        diag_log "[FLO][Command] Client command voting initialized";
    }
] call CBA_fnc_waitUntilAndExecute;
