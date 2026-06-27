if (!hasInterface) exitWith {};
if (isNull player) exitWith {};

if (!alive player) exitWith {
    ["You are already down. The active casualty or respawn state controls ticket use.", "info", "Tickets"] call FLO_fnc_notify;
};

private _side = side group player;

if !(_side in [west, east]) exitWith {
    ["Manual respawn is only available after joining BLUFOR or OPFOR.", "warning", "Tickets"] call FLO_fnc_notify;
};

private _message = if (FLO_TicketRespawnLocked) then {
    if (FLO_TicketRespawnLockMessage isNotEqualTo "") then {
        format ["%1 Manual respawn will still kill you, but you will remain locked until command buys more tickets. Continue?", FLO_TicketRespawnLockMessage]
    } else {
        "Your side has no respawn tickets. Manual respawn will kill you, but you will remain locked until command buys more tickets. Continue?"
    }
} else {
    format ["Manual respawn will kill you and consume %1 side ticket. Continue?", FLO_TicketRespawnCost]
};

[_message] call FLO_fnc_ticketOpenManualRespawnDialog;
