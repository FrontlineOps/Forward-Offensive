if (!hasInterface) exitWith {};
if !(isClass (configFile >> "CfgPatches" >> "acre_main")) exitWith {};

[
    {!isNull player},
    {
        [true, true] call acre_api_fnc_setupMission;

        [
            {[] call acre_api_fnc_isInitialized},
            {
                {
                    private _radio = [_x] call acre_api_fnc_getRadioByType;
                    if (_radio isNotEqualTo "") then {
                        [_radio, 1] call acre_api_fnc_setRadioChannel;
                    };
                } forEach ["ACRE_PRC343", "ACRE_PRC148", "ACRE_PRC152", "ACRE_PRC77", "ACRE_PRC117F"];
            },
            []
        ] call CBA_fnc_waitUntilAndExecute;
    },
    []
] call CBA_fnc_waitUntilAndExecute;
