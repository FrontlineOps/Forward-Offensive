if (!isServer) exitWith {};

FLO_IntelBodies = createHashMap;
FLO_IntelBaseFinds = createHashMapFromArray [
    ["WEST", 0],
    ["EAST", 0]
];

FLO_IntelEntityKilledEh = [
    "FLO_eventEntityKilled",
    {
        params ["_unit", "_killer", "_instigator", "_useEffects"];

        [_unit, _killer, _instigator, _useEffects] call FLO_fnc_intelRegisterBody;
    }
] call CBA_fnc_addEventHandler;

diag_log format [
    "[FLO][Intel] Intel system initialized dropChance=%1 baseChance=%2 commandRoleChance=%3 baseRadius=%4-%5 playerRadius=%6 commandRoleRadius=%7",
    FLO_IntelDropChance,
    FLO_IntelBaseChance,
    FLO_IntelCommandRoleChance,
    FLO_IntelBaseRadiusStart,
    FLO_IntelBaseRadiusMin,
    FLO_IntelPlayerMarkerRadius,
    FLO_IntelCommandRoleMarkerRadius
];
