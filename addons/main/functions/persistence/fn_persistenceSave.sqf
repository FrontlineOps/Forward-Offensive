params [["_reason", "manual", [""]]];

if (!isServer) exitWith { false };
if (!FLO_PersistenceEnabled) exitWith { false };

private _snapshot = [] call FLO_fnc_persistenceBuildSnapshot;

profileNamespace setVariable [FLO_PersistenceKey, _snapshot];
saveProfileNamespace;

FLO_PersistenceDirty = false;
FLO_PersistenceSaveScheduled = false;
FLO_PersistenceLastSaveAt = diag_tickTime;

private _snapshotMap = createHashMapFromArray _snapshot;
private _fobs = createHashMapFromArray (_snapshotMap get "fobs");
private _store = createHashMapFromArray (_snapshotMap get "store");

diag_log format [
    "[FLO][Persistence] Saved snapshot reason=%1 key=%2 fobs=%3 ids=%4 pendingVehicles=%5 vehicles=%6 players=%7",
    _reason,
    FLO_PersistenceKey,
    count (_fobs get "records"),
    count (_snapshotMap get "idsLogistics"),
    count (_store get "pendingVehicles"),
    count (_snapshotMap get "vehicles"),
    count (_snapshotMap get "players")
];

true
