if (!isServer) exitWith {};

FLO_FOBs = createHashMap;
FLO_FOBNextId = 0;
FLO_FOBStarterUsed = createHashMapFromArray [
    ["WEST", false],
    ["EAST", false]
];
FLO_FOBDeployCost = 1500;
FLO_FOBBuildRadius = 100;
FLO_FOBMinDistance = 500;
FLO_FOBBuildClasses = [
    "Land_Cargo_HQ_V1_F",
    "Land_Cargo_HQ_V3_F",
    "Land_Cargo_HQ_V4_F",
    "Land_Medevac_HQ_V1_F"
];
FLO_FOBSideClasses = createHashMapFromArray [
    ["WEST", "Land_Cargo_HQ_V1_F"],
    ["EAST", "Land_Cargo_HQ_V3_F"]
];

diag_log format [
    "[FLO][FOB] FOB system initialized deployCost=%1 buildRadius=%2 minDistance=%3 starterFobs=1PerSide",
    FLO_FOBDeployCost,
    FLO_FOBBuildRadius,
    FLO_FOBMinDistance
];
