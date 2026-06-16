params ["_unit", "_locked", ["_message", ""], ["_attempt", 0]];

if (!isServer) exitWith {};
if (isNull _unit) exitWith {};
if (!isPlayer _unit) exitWith {};

private _owner = owner _unit;

if (_owner > 2) exitWith {
    [_locked, _message, FLO_TicketRespawnDelay, FLO_TicketNoTicketRespawnDelay] remoteExecCall ["FLO_fnc_ticketApplyRespawnLock", _owner];
};

if (hasInterface && {player isEqualTo _unit}) exitWith {
    [_locked, _message, FLO_TicketRespawnDelay, FLO_TicketNoTicketRespawnDelay] call FLO_fnc_ticketApplyRespawnLock;
};

if (_attempt < 20) exitWith {
    [
        {
            params ["_unit", "_locked", "_message", "_attempt"];
            [_unit, _locked, _message, _attempt + 1] call FLO_fnc_ticketSyncPlayer;
        },
        [_unit, _locked, _message, _attempt],
        0.5
    ] call CBA_fnc_waitAndExecute;
};

diag_log format [
    "[FLO][Tickets] Could not sync respawn lock to %1 owner=%2 locked=%3",
    _unit,
    _owner,
    _locked
];
