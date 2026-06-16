if (!isServer) exitWith {};

FLO_SpawnSideAssignmentCounts = createHashMapFromArray [
    ["WEST", 0],
    ["EAST", 0]
];

private _westZone = FLO_DeploymentZones get "WEST";
private _eastZone = FLO_DeploymentZones get "EAST";

diag_log format [
    "[FLO][Spawn] Spawn assignment system initialized westCell=%1 eastCell=%2",
    _westZone get "cellId",
    _eastZone get "cellId"
];
