if (!isServer) exitWith {};

FLO_FOBs = createHashMap;
FLO_FOBNextId = 0;
FLO_FOBStarterUsed = createHashMapFromArray [
    ["WEST", false],
    ["EAST", false]
];

FLO_FOBRespawnLoopHandle = [
    {
        {
            [_x] call FLO_fnc_fobSyncRespawn;
        } forEach keys FLO_FOBs;
    },
    FLO_BaseRespawnCheckInterval,
    []
] call CBA_fnc_addPerFrameHandler;

diag_log format [
    "[FLO][FOB] Base system initialized fobCost=%1 copCost=%2 fobRadius=%3 copRadius=%4 starterFobs=1PerSide copMaxPerSide=%5",
    FLO_FOBDeployCost,
    FLO_COPDeployCost,
    FLO_FOBBuildRadius,
    FLO_COPBuildRadius,
    FLO_COPMaxPerSide
];
