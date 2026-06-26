params [["_delay", FLO_TicketSnapshotBroadcastDelay, [0]]];

if (!isServer) exitWith {};
if (FLO_TicketSnapshotScheduled) exitWith {};

FLO_TicketSnapshotScheduled = true;

[
    {
        FLO_TicketSnapshotScheduled = false;
        [0] call FLO_fnc_ticketSendSnapshot;
    },
    [],
    _delay
] call CBA_fnc_waitAndExecute;
