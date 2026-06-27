if (!hasInterface) exitWith {};
if !(isClass (configFile >> "CfgPatches" >> "acre_main")) exitWith {};

[
    {!isNull player},
    {
        [true, true] call acre_api_fnc_setupMission;

        private _shortRangeLabels = [
            [1, "ALPHA 1-1"],
            [2, "ALPHA 1-2"],
            [3, "ALPHA 1-3"],
            [4, "ALPHA 1-4"],
            [5, "ALPHA 2-1"],
            [6, "ALPHA 2-2"],
            [7, "BRAVO 1-1"],
            [8, "BRAVO 1-2"],
            [9, "CHARLIE 1-1"],
            [10, "DELTA 1-1"]
        ];
        private _commandLabels = [
            [1, "PLATOON"],
            [2, "COMMAND"],
            [3, "LOGISTICS"],
            [4, "AIR"],
            [5, "ARMOR"],
            [6, "FIRES"],
            [7, "CAS"],
            [8, "MEDEVAC"],
            [9, "RECON"],
            [10, "ADMIN"]
        ];
        private _presetNames = ["default", "default2", "default3", "default4"];
        private _shortRangeRadios = ["ACRE_PRC343", "ACRE_BF888S"];
        private _commandRadios = ["ACRE_PRC148", "ACRE_PRC152", "ACRE_PRC77", "ACRE_PRC117F", "ACRE_SEM52SL", "ACRE_SEM70"];

        {
            private _radioType = _x;
            {
                private _preset = _x;
                {
                    _x params ["_channel", "_label"];
                    [_radioType, _preset, _channel, "label", _label] call acre_api_fnc_setPresetChannelField;
                } forEach _shortRangeLabels;
            } forEach _presetNames;
        } forEach _shortRangeRadios;

        {
            private _radioType = _x;
            {
                private _preset = _x;
                {
                    _x params ["_channel", "_label"];
                    [_radioType, _preset, _channel, "label", _label] call acre_api_fnc_setPresetChannelField;
                } forEach _commandLabels;
            } forEach _presetNames;
        } forEach _commandRadios;

        [
            {[] call acre_api_fnc_isInitialized},
            {
                [] call FLO_fnc_clientAcreApplyRadioChannels;

                [
                    {
                        private _shortRangeChannel = group player getVariable ["FLO_AcreShortRangeChannel", 0];
                        if (
                            (FLO_AcreLastGroup isNotEqualTo (group player)) ||
                            {_shortRangeChannel isNotEqualTo FLO_AcreLastShortRangeChannel}
                        ) then {
                            [] call FLO_fnc_clientAcreApplyRadioChannels;
                        };
                    },
                    10,
                    []
                ] call CBA_fnc_addPerFrameHandler;
            },
            []
        ] call CBA_fnc_waitUntilAndExecute;
    },
    []
] call CBA_fnc_waitUntilAndExecute;
