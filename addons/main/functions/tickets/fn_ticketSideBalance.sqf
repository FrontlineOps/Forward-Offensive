params ["_side"];

if (!isServer) exitWith { 0 };

private _sideKey = [_side] call FLO_fnc_resourceSideKey;

FLO_TicketBalances get _sideKey
