if (!hasInterface) exitWith {};

[
    { !isNull player },
    {
        player addAction [
            "<t size='1.5' color='#4DA3FF' font='RobotoCondensedBold'>Deploy FOB</t>",
            { [player] remoteExecCall ["FLO_fnc_fobRequestDeploy", 2]; },
            nil,
            1.5,
            true,
            true,
            "",
            "alive _this && {[_this, 'fob'] call FLO_fnc_commandPlayerHasAuthority}"
        ];

        player addAction [
            "<t size='1.5' color='#25D7FF' font='RobotoCondensedBold'>Deploy COP</t>",
            { [player, "COP"] remoteExecCall ["FLO_fnc_fobRequestDeploy", 2]; },
            nil,
            1.45,
            true,
            true,
            "",
            "alive _this && {[_this, 'fob'] call FLO_fnc_commandPlayerHasAuthority}"
        ];

        {
            private _className = _x;

            {
                if ((_x getVariable ["FLO_FOB_Id", ""]) isNotEqualTo "") then {
                    [_x] call FLO_fnc_fobAddClientAction;
                };
            } forEach allMissionObjects _className;
        } forEach FLO_FOBBuildClasses;

        diag_log "[FLO][FOB] Client FOB actions initialized";
    }
] call CBA_fnc_waitUntilAndExecute;
