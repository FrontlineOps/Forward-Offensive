params [["_force", false]];

if (!isServer) exitWith {};

private _now = diag_tickTime;
private _snapshot = [] call FLO_fnc_objectiveBuildSnapshot;
private _snapshotKey = str _snapshot;
private _changed = !(_snapshotKey isEqualTo FLO_ObjectiveLastSnapshotKey);
private _heartbeatDue = (_now - FLO_ObjectiveLastFullSnapshotAt) >= FLO_ObjectiveSnapshotHeartbeat;
private _minIntervalDue = (_now - FLO_ObjectiveLastPublishAt) >= FLO_ObjectivePublishMinInterval;

if (_force || {(_changed && _minIntervalDue) || _heartbeatDue}) then {
    FLO_ObjectiveSnapshot = _snapshot;
    FLO_ObjectiveLastSnapshotKey = _snapshotKey;
    FLO_ObjectiveLastPublishAt = _now;

    if (_force || {_heartbeatDue}) then {
        FLO_ObjectiveLastFullSnapshotAt = _now;
    };

    publicVariable "FLO_ObjectiveSnapshot";
    FLO_ObjectivePublicationsSent = FLO_ObjectivePublicationsSent + 1;
};
