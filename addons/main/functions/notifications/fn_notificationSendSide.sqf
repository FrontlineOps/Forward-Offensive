params [
    ["_side", sideUnknown, [sideUnknown]],
    ["_payload", createHashMap, [createHashMap]]
];

if (!isServer) exitWith {};
if !(_side in [west, east]) exitWith {};

{
    if ((side group _x) isEqualTo _side) then {
        [_x, _payload] call FLO_fnc_notificationSendPlayer;
    };
} forEach allPlayers;
