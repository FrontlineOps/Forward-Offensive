if (!isServer) exitWith {};

FLO_StoreCatalogCache = createHashMap;
FLO_StorePendingVehicles = [];
FLO_StorePendingVehicleCounter = 0;
FLO_StorePurchasedVehicles = createHashMap;
FLO_StorePurchasedVehicleCounter = 0;
FLO_StorePendingVehicleTtl = 900;
FLO_StoreVehicleSpawnRadius = 40;

diag_log "[FLO][Store] Store system initialized";
