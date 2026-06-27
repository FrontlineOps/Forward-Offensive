FLO_TicketInitialBalance = 25;
FLO_TicketRespawnCost = 1;
FLO_TicketRespawnDelay = 10;
FLO_TicketNoTicketRespawnDelay = 999999;
FLO_TicketManualRespawnButtonIdc = 1010;
FLO_TicketSnapshotBroadcastDelay = 0.25;
FLO_TicketPurchasePacks = [
    ["ticket_5", "Reinforcements x5", 5, 900],
    ["ticket_10", "Reinforcements x10", 10, 1700],
    ["ticket_25", "Reinforcements x25", 25, 3800]
];
FLO_TicketBalances = createHashMap;
FLO_TicketPurchasedTotal = createHashMap;
FLO_TicketConsumedTotal = createHashMap;
FLO_TicketDeathStates = createHashMap;
FLO_TicketHandledRespawns = createHashMap;
FLO_TicketPlayerSides = createHashMap;
FLO_TicketDisconnectedPlayers = createHashMap;
FLO_TicketAceMedicalDeathEh = -1;
FLO_TicketClientRespawnEh = -1;
FLO_TicketHandleDisconnectEh = -1;
FLO_TicketPlayerDisconnectedEh = -1;
FLO_TicketManualRespawnPfh = -1;
FLO_TicketRespawnLocked = false;
FLO_TicketRespawnLockMessage = "";
FLO_TicketRevision = 0;
FLO_TicketSnapshot = createHashMap;
FLO_TicketSnapshotScheduled = false;
