if (!isServer) exitWith {};

FLO_ResourceSystemRunning = true;

FLO_ResourceLoopHandle = [
    {
        params ["_args", "_handle"];

        if (!FLO_ResourceSystemRunning) exitWith {
            [_handle] call CBA_fnc_removePerFrameHandler;
            FLO_ResourceLoopHandle = -1;
        };

        [] call FLO_fnc_resourceTick;
    },
    FLO_ResourceTickInterval,
    []
] call CBA_fnc_addPerFrameHandler;

diag_log format [
    "[FLO][Resource] Resource CBA update handler started with interval %1 seconds",
    FLO_ResourceTickInterval
];
