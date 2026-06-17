if (!hasInterface) exitWith {};

FLO_ObjectiveClientMarkers = createHashMap;
FLO_ObjectiveClientGridMarkers = createHashMap;
FLO_ObjectiveClientGridMarkerKeys = createHashMap;
FLO_ObjectiveClientObjectiveRecords = createHashMap;
FLO_ObjectiveClientLastSnapshot = [];
FLO_ObjectiveClientLastGridSnapshot = [];
FLO_ObjectiveAreaActiveId = "";
FLO_ObjectiveAreaBrowserReady = false;

[
    { !isNull player },
    {
        FLO_ObjectiveClientNeutralGridSnapshot = [] call FLO_fnc_objectiveBuildNeutralGridSnapshot;
        [FLO_ObjectiveClientNeutralGridSnapshot] call FLO_fnc_objectiveApplyGridSnapshot;
        [] call FLO_fnc_objectiveAreaClientInit;
        [
            "FOOF",
            "openObjectiveAreaPanel",
            ["Open AO Panel", "Open the AO objective panel for the area you are standing in."],
            { [] call FLO_fnc_objectiveToggleAreaDialog; true },
            {},
            [24, [true, true, false]],
            false
        ] call CBA_fnc_addKeybind;
        [player] remoteExecCall ["FLO_fnc_objectiveRequestSnapshot", 2];

        diag_log format [
            "[FLO][Objective] Client objective visualizer ready neutralCells=%1 gridMarkers=%2",
            count FLO_ObjectiveClientNeutralGridSnapshot,
            count (keys FLO_ObjectiveClientGridMarkers)
        ];
    }
] call CBA_fnc_waitUntilAndExecute;

diag_log "[FLO][Objective] Client objective visualizer initialized";
