if (!isServer) exitWith {};

if (FLO_ObjectiveSystemRunning) exitWith {
    diag_log "[FLO][Objective] Objective server loop is already running";
};

FLO_ObjectiveSystemRunning = true;

/*
    Server-owned scheduled worker.
    Interval: FLO_ObjectiveUpdateInterval seconds.
    Exit condition: set FLO_ObjectiveSystemRunning to false.
    Cost control: one worker evaluates known objective cells only; no per-cell spawns.
*/
FLO_ObjectiveLoopHandle = [] spawn {
    scriptName "FLO_ObjectiveServerLoop";

    while {FLO_ObjectiveSystemRunning} do {
        [] call FLO_fnc_objectiveEvaluate;
        sleep FLO_ObjectiveUpdateInterval;
    };
};

diag_log format [
    "[FLO][Objective] Objective server loop started with interval %1 seconds",
    FLO_ObjectiveUpdateInterval
];
