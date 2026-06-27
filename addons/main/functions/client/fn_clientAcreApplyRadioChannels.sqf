private _shortRangeChannel = [] call FLO_fnc_clientAcreGroupShortRangeChannel;

{
    private _radio = [_x] call acre_api_fnc_getRadioByType;
    if (_radio isNotEqualTo "") then {
        [_radio, _shortRangeChannel] call acre_api_fnc_setRadioChannel;
    };
} forEach ["ACRE_PRC343", "ACRE_BF888S"];

{
    private _radio = [_x] call acre_api_fnc_getRadioByType;
    if (_radio isNotEqualTo "") then {
        [_radio, 2] call acre_api_fnc_setRadioChannel;
    };
} forEach ["ACRE_PRC148", "ACRE_PRC152", "ACRE_PRC77", "ACRE_PRC117F", "ACRE_SEM52SL", "ACRE_SEM70"];

FLO_AcreLastGroup = group player;
FLO_AcreLastShortRangeChannel = _shortRangeChannel;
