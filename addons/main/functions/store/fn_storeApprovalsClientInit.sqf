if (!hasInterface) exitWith {};

[
    { !isNull player },
    {
        [
            "FOOF",
            "openStoreApprovals",
            ["Open Store Approvals", "Open pending Store checkout approvals."],
            { [] call FLO_fnc_storeOpenApprovalsDialog; true },
            {},
            [30, [true, true, false]],
            false
        ] call CBA_fnc_addKeybind;

        diag_log "[FLO][Store] Client approvals keybind initialized";
    }
] call CBA_fnc_waitUntilAndExecute;
