if (!hasInterface) exitWith {};

[
    { !isNull player },
    {
        [
            "FOOF",
            "openDeploymentPanel",
            ["Open Deployment Panel", "Open the FOOF FOB/COP deployment panel."],
            { [] call FLO_fnc_fobOpenDeployDialog; true },
            {},
            [32, [true, true, false]],
            false
        ] call CBA_fnc_addKeybind;

        [] call FLO_fnc_fobRefreshClientActions;

        [
            { [] call FLO_fnc_fobRefreshClientActions; },
            [],
            FLO_FOBClientActionRefreshInterval
        ] call CBA_fnc_waitAndExecute;

        diag_log "[FLO][FOB] Client base actions and deployment keybind initialized";
    }
] call CBA_fnc_waitUntilAndExecute;
