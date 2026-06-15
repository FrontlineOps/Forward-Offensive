if (!isServer) exitWith {};

private _t0 = diag_tickTime;
private _presence = [] call FLO_fnc_objectiveCollectPresence;
private _presenceMs = (diag_tickTime - _t0) * 1000;
private _resolutionT0 = diag_tickTime;
private _cellsChanged = 0;
private _objectivesChanged = 0;

{
    private _cell = FLO_ObjectiveCells get _x;

    if ([_cell, _presence] call FLO_fnc_objectiveEvaluateCell) then {
        _cellsChanged = _cellsChanged + 1;
    };
} forEach keys FLO_ObjectiveCells;

{
    private _objective = FLO_Objectives get _x;

    if ([_objective] call FLO_fnc_objectiveResolveObjective) then {
        _objectivesChanged = _objectivesChanged + 1;
    };
} forEach keys FLO_Objectives;

private _resolutionMs = (diag_tickTime - _resolutionT0) * 1000;
private _publishT0 = diag_tickTime;

[] call FLO_fnc_objectivePublishSnapshot;

private _publishMs = (diag_tickTime - _publishT0) * 1000;
private _totalMs = (diag_tickTime - _t0) * 1000;

FLO_ObjectiveLastDiagnostics = createHashMapFromArray [
    ["objectiveCount", count (keys FLO_Objectives)],
    ["cellCount", count (keys FLO_ObjectiveCells)],
    ["playersConsidered", count _presence],
    ["cellsChanged", _cellsChanged],
    ["objectivesChanged", _objectivesChanged],
    ["publicationsSent", FLO_ObjectivePublicationsSent],
    ["evalMsTotal", _totalMs],
    ["evalMsPresence", _presenceMs],
    ["evalMsResolution", _resolutionMs],
    ["evalMsPublish", _publishMs]
];

if (_totalMs > FLO_ObjectivePerfLogThresholdMs) then {
    diag_log format [
        "[FLO][PERF] Objective eval took %1 ms objectives=%2 cells=%3 players=%4 cellsChanged=%5 objectivesChanged=%6 publishMs=%7",
        _totalMs,
        count (keys FLO_Objectives),
        count (keys FLO_ObjectiveCells),
        count _presence,
        _cellsChanged,
        _objectivesChanged,
        _publishMs
    ];
};
