params [["_force", false], ["_dirtyCellIds", []], ["_dirtyObjectiveIds", []]];

if (!isServer) exitWith {};

private _now = diag_tickTime;
private _heartbeatDue = (_now - FLO_ObjectiveLastFullSnapshotAt) >= FLO_ObjectiveSnapshotHeartbeat;

{
    FLO_ObjectivePendingGridCellIds set [_x, true];
} forEach _dirtyCellIds;

{
    FLO_ObjectivePendingObjectiveIds set [_x, true];
} forEach _dirtyObjectiveIds;

private _pendingCellIds = keys FLO_ObjectivePendingGridCellIds;
private _pendingObjectiveIds = keys FLO_ObjectivePendingObjectiveIds;

if (!_force && {!_heartbeatDue} && {(count _pendingCellIds) isEqualTo 0} && {(count _pendingObjectiveIds) isEqualTo 0}) exitWith {};

private _minIntervalDue = (_now - FLO_ObjectiveLastPublishAt) >= FLO_ObjectivePublishMinInterval;

if (!_force && {!_heartbeatDue} && {!_minIntervalDue}) exitWith {};

if (_force || {_heartbeatDue}) then {
    [0] call FLO_fnc_objectiveSendFullSnapshot;
    FLO_ObjectiveLastPublishAt = _now;
    FLO_ObjectiveLastFullSnapshotAt = _now;

    FLO_ObjectivePendingGridCellIds = createHashMap;
    FLO_ObjectivePendingObjectiveIds = createHashMap;
    FLO_ObjectivePublicationsSent = FLO_ObjectivePublicationsSent + 1;
} else {
    private _published = false;

    if (_pendingCellIds isNotEqualTo []) then {
        FLO_ObjectiveGridSnapshotDelta = [_pendingCellIds] call FLO_fnc_objectiveBuildGridSnapshot;
        [FLO_ObjectiveGridSnapshotDelta, false] remoteExecCall ["FLO_fnc_objectiveReceiveGridSnapshot", 0];
        _published = true;
    };

    if (_pendingObjectiveIds isNotEqualTo []) then {
        FLO_ObjectiveSnapshotDelta = [_pendingObjectiveIds] call FLO_fnc_objectiveBuildSnapshot;
        [FLO_ObjectiveSnapshotDelta, false] remoteExecCall ["FLO_fnc_objectiveReceiveSnapshot", 0];
        _published = true;
    };

    if (_published) then {
        FLO_ObjectivePendingGridCellIds = createHashMap;
        FLO_ObjectivePendingObjectiveIds = createHashMap;
        FLO_ObjectiveLastPublishAt = _now;
        FLO_ObjectivePublicationsSent = FLO_ObjectivePublicationsSent + 1;
    };
};
