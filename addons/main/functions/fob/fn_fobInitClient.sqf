if (!hasInterface) exitWith {};

FLO_FOBDeployCost = 1500;
FLO_FOBBuildRadius = 100;
FLO_FOBBuildClasses = [
    "Land_Cargo_HQ_V1_F",
    "Land_Cargo_HQ_V3_F",
    "Land_Cargo_HQ_V4_F",
    "Land_Medevac_HQ_V1_F"
];

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
