if (!isServer) exitWith {};

FLO_TicketBalances = createHashMapFromArray [
    ["WEST", FLO_TicketInitialBalance],
    ["EAST", FLO_TicketInitialBalance]
];

FLO_TicketPurchasedTotal = createHashMapFromArray [
    ["WEST", 0],
    ["EAST", 0]
];

FLO_TicketConsumedTotal = createHashMapFromArray [
    ["WEST", 0],
    ["EAST", 0]
];

FLO_TicketRevision = 0;

FLO_TicketEntityRespawnedEh = addMissionEventHandler [
    "EntityRespawned",
    {
        params ["_newEntity", "_oldEntity"];
        [_newEntity, _oldEntity] call FLO_fnc_ticketHandleRespawn;
    }
];

diag_log format [
    "[FLO][Tickets] Ticket system initialized initialBalance=%1 respawnCost=%2",
    FLO_TicketInitialBalance,
    FLO_TicketRespawnCost
];
