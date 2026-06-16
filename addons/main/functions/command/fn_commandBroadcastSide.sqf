params ["_side"];

if (!isServer) exitWith {};

{
    [_x] call FLO_fnc_commandSendSnapshot;
} forEach ([_side] call FLO_fnc_commandSidePlayers);
