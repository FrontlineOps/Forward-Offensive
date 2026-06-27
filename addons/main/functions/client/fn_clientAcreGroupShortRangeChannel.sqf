private _channel = group player getVariable ["FLO_AcreShortRangeChannel", 0];

if (_channel < 1 || {_channel > 10}) then {
    if (isMultiplayer) then {
        [player] remoteExecCall ["FLO_fnc_clientAcreRequestGroupChannel", 2];
    } else {
        [player, 0] call FLO_fnc_clientAcreRequestGroupChannel;
    };

    1
} else {
    _channel
}
