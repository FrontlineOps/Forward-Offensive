if (!isServer) exitWith {};

[
    {
        !isNil "FLO_ObjectiveCells"
        && {!isNil "FLO_Objectives"}
        && {!isNil "FLO_DeploymentZones"}
        && {!isNil "FLO_ResourceBalances"}
        && {!isNil "FLO_TicketBalances"}
        && {!isNil "FLO_CommandSideState"}
        && {!isNil "FLO_FOBs"}
        && {!isNil "FLO_StorePendingVehicles"}
        && {!isNil "FLO_StorePurchasedVehicles"}
        && {!isNil "FLO_StorePurchasedVehicleCounter"}
        && {!isNil "IDS_Logistics_PlacedEntities"}
    },
    {
        [] call FLO_fnc_persistenceInitServer;
    },
    []
] call CBA_fnc_waitUntilAndExecute;
