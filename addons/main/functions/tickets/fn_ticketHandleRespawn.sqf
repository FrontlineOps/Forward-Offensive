params ["_unit", "_corpse"];

if (!isServer) exitWith {};
if (isNull _unit) exitWith {};
if (isNull _corpse) exitWith {};
if (!isPlayer _unit) exitWith {};

private _side = side group _unit;

if !(_side in [west, east]) exitWith {};

private _uid = getPlayerUID _unit;

if (_uid isEqualTo "") exitWith {};
if (_unit getVariable ["FLO_TicketRespawnHandled", false]) exitWith {};
_unit setVariable ["FLO_TicketRespawnHandled", true];

if !([_side, FLO_TicketRespawnCost, format ["respawn %1", _uid]] call FLO_fnc_ticketConsume) exitWith {
    private _sideKey = [_side] call FLO_fnc_resourceSideKey;
    private _message = format ["%1 has no respawn tickets.", _sideKey];

    [_unit, true, _message] call FLO_fnc_ticketSyncPlayer;
    _unit setDamage 1;

    diag_log format [
        "[FLO][Tickets] Denied respawn for uid=%1 side=%2 noTickets",
        _uid,
        _sideKey
    ];
};

private _balance = [_side] call FLO_fnc_ticketSideBalance;
private _locked = _balance <= 0;
private _message = if (_locked) then {
    "Respawn ticket consumed. No tickets remain."
} else {
    format ["Respawn ticket consumed. %1 tickets remain.", _balance]
};

[_unit, _locked, _message] call FLO_fnc_ticketSyncPlayer;
