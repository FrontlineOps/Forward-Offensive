if (!isServer) exitWith {};

FLO_ObjectiveSystemRunning = true;

FLO_ObjectiveLoopHandle = [
    {
        params ["_args", "_handle"];

        if (!FLO_ObjectiveSystemRunning) exitWith {
            [_handle] call CBA_fnc_removePerFrameHandler;
            FLO_ObjectiveLoopHandle = -1;
        };

        [] call FLO_fnc_objectiveEvaluate;
    },
    FLO_ObjectiveUpdateInterval,
    []
] call CBA_fnc_addPerFrameHandler;

diag_log format [
    "[FLO][Objective] Objective CBA update handler started with interval %1 seconds",
    FLO_ObjectiveUpdateInterval
];
