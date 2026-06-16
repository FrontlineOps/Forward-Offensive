if (!isServer) exitWith {};

FLO_IntelBodies = createHashMap;
FLO_IntelBaseFinds = createHashMapFromArray [
    ["WEST", 0],
    ["EAST", 0]
];

addMissionEventHandler [
    "EntityKilled",
    {
        params ["_unit", "_killer", "_instigator", "_useEffects"];

        [_unit, _killer, _instigator, _useEffects] call FLO_fnc_intelRegisterBody;
    }
];

diag_log format [
    "[FLO][Intel] Intel system initialized dropChance=%1 baseChance=%2 baseRadius=%3-%4 playerRadius=%5",
    FLO_IntelDropChance,
    FLO_IntelBaseChance,
    FLO_IntelBaseRadiusStart,
    FLO_IntelBaseRadiusMin,
    FLO_IntelPlayerMarkerRadius
];
