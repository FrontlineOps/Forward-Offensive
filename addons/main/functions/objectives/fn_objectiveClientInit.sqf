if (!hasInterface) exitWith {};

FLO_ObjectiveClientMarkers = createHashMap;
FLO_ObjectiveClientGridMarkers = createHashMap;
FLO_ObjectiveClientGridMarkerKeys = createHashMap;
FLO_ObjectiveClientLastSnapshot = [];
FLO_ObjectiveClientLastGridSnapshot = [];

[
    { !isNull player },
    {
        FLO_ObjectiveClientNeutralGridSnapshot = [] call FLO_fnc_objectiveBuildNeutralGridSnapshot;
        [FLO_ObjectiveClientNeutralGridSnapshot] call FLO_fnc_objectiveApplyGridSnapshot;
        [player] remoteExecCall ["FLO_fnc_objectiveRequestSnapshot", 2];

        diag_log format [
            "[FLO][Objective] Client objective visualizer ready neutralCells=%1 gridMarkers=%2",
            count FLO_ObjectiveClientNeutralGridSnapshot,
            count (keys FLO_ObjectiveClientGridMarkers)
        ];
    }
] call CBA_fnc_waitUntilAndExecute;

diag_log "[FLO][Objective] Client objective visualizer initialized";
