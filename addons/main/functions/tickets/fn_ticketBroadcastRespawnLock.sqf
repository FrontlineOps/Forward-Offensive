params ["_side", "_locked", ["_message", ""]];

if (!isServer) exitWith {};

{
    if ((side group _x) isEqualTo _side) then {
        [_x, _locked, _message] call FLO_fnc_ticketSyncPlayer;
    };
} forEach allPlayers;
