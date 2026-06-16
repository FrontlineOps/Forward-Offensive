params [["_token", "", [""]]];

if (!hasInterface) exitWith {};
if (_token isNotEqualTo FLO_AnnouncementToken) exitWith {};

{
    if (!isNull _x) then {
        _x ctrlSetFade 1;
        _x ctrlCommit 0.22;
    };
} forEach FLO_AnnouncementControls;

[
    {
        params ["_token"];

        if (_token isNotEqualTo FLO_AnnouncementToken) exitWith {};

        {
            if (!isNull _x) then {
                ctrlDelete _x;
            };
        } forEach FLO_AnnouncementControls;

        FLO_AnnouncementControls = [];
        FLO_AnnouncementToken = "";
    },
    [_token],
    0.24
] call CBA_fnc_waitAndExecute;
