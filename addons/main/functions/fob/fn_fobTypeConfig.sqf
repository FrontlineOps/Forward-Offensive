params [["_baseType", "FOB", [""]]];

private _type = toUpper _baseType;

if (_type isEqualTo "COP") exitWith {
    createHashMapFromArray [
        ["type", "COP"],
        ["label", "COP"],
        ["deployCost", FLO_COPDeployCost],
        ["buildRadius", FLO_COPBuildRadius],
        ["minDistance", FLO_COPMinDistance],
        ["maxPerSide", FLO_COPMaxPerSide],
        ["sideClasses", FLO_COPSideClasses],
        ["logisticsCategories", +FLO_COPLogisticsCategories],
        ["storeEnabled", false],
        ["vehicleStoreEnabled", false],
        ["ticketStoreEnabled", false],
        ["respawnEnabled", true],
        ["enemyDisableRadius", FLO_COPEnemyDisableRadius],
        ["markerSuffix", "COP"]
    ]
};

createHashMapFromArray [
    ["type", "FOB"],
    ["label", "FOB"],
    ["deployCost", FLO_FOBDeployCost],
    ["buildRadius", FLO_FOBBuildRadius],
    ["minDistance", FLO_FOBMinDistance],
    ["maxPerSide", -1],
    ["sideClasses", FLO_FOBSideClasses],
    ["logisticsCategories", []],
    ["storeEnabled", true],
    ["vehicleStoreEnabled", true],
    ["ticketStoreEnabled", true],
    ["respawnEnabled", true],
    ["enemyDisableRadius", 0],
    ["markerSuffix", "FOB"]
]
