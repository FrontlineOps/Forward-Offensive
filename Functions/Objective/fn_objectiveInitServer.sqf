if (!isServer) exitWith {};

if (!isNil "FLO_Objectives") exitWith {
    diag_log "[FLO][Objective] Objective system already initialized";
};

FLO_Objectives = createHashMap;
FLO_ObjectiveCells = createHashMap;
FLO_ObjectiveSnapshot = [];
FLO_ObjectiveLastSnapshotKey = "";
FLO_ObjectiveLastPublishAt = -9999;
FLO_ObjectiveLastFullSnapshotAt = -9999;
FLO_ObjectivePublicationsSent = 0;
FLO_ObjectiveSystemRunning = false;
FLO_ObjectiveLoopHandle = scriptNull;
FLO_ObjectiveLastDiagnostics = createHashMap;

FLO_ObjectiveUpdateInterval = 5;
FLO_ObjectiveSnapshotHeartbeat = 30;
FLO_ObjectivePublishMinInterval = 2;
FLO_ObjectiveMinCapturePlayers = 1;
FLO_ObjectiveCellCaptureRate = 0.035;
FLO_ObjectiveCellDecayRate = 0.01;
FLO_ObjectivePerfLogThresholdMs = 20;

private _definitions = [] call FLO_fnc_objectiveDefinitions;

{
    [_x] call FLO_fnc_objectiveRegister;
} forEach _definitions;

[] call FLO_fnc_objectivePublishSnapshot;

FLO_ObjectivePlayerConnectedEh = addMissionEventHandler [
    "PlayerConnected",
    {
        [] spawn {
            sleep 3;

            if (isServer) then {
                [true] call FLO_fnc_objectivePublishSnapshot;
            };
        };
    }
];

if ((count _definitions) > 0) then {
    [] call FLO_fnc_objectiveStartLoop;
} else {
    diag_log "[FLO][Objective] No objective definitions configured; objective loop not started";
};

diag_log format [
    "[FLO][Objective] Objective system initialized objectives=%1 cells=%2",
    count (keys FLO_Objectives),
    count (keys FLO_ObjectiveCells)
];
