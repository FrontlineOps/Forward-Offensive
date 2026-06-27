params ["_uid", ["_owner", 0, [0]]];

if (!isServer) exitWith { false };
if !(_uid in FLO_PersistencePlayerRecords) exitWith { false };

private _unit = objNull;

{
    if ((getPlayerUID _x) isEqualTo _uid) exitWith {
        _unit = _x;
    };
} forEach allPlayers;

if (isNull _unit) exitWith { false };

private _recordData = FLO_PersistencePlayerRecords get _uid;
private _record = createHashMapFromArray _recordData;
private _currentSideKey = [side group _unit] call FLO_fnc_persistenceSideKey;

if (_currentSideKey isEqualTo "UNKNOWN") exitWith { false };

private _savedSideKey = "";

if ("sideKey" in _record) then {
    _savedSideKey = _record get "sideKey";
};

if ((_savedSideKey isEqualTo "") || {_savedSideKey isNotEqualTo _currentSideKey}) exitWith {
    if (_owner <= 0) then {
        _owner = owner _unit;
    };

    private _oldPendingCount = count FLO_StorePendingVehicles;
    private _oldApprovalCount = count FLO_StorePendingApprovals;

    FLO_PersistencePlayerRecords deleteAt _uid;
    FLO_SpawnPlayerAssignments deleteAt _uid;
    FLO_StorePendingVehicles = FLO_StorePendingVehicles select {
        !(((_x get "playerUid") isEqualTo _uid) && {(_savedSideKey isEqualTo "") || {(_x get "sideKey") isEqualTo _savedSideKey}})
    };
    FLO_StorePendingApprovals = FLO_StorePendingApprovals select {
        !(((_x get "playerUid") isEqualTo _uid) && {(_savedSideKey isEqualTo "") || {(_x get "sideKey") isEqualTo _savedSideKey}})
    };

    if (_savedSideKey in ["WEST", "EAST"]) then {
        FLO_ResourcePersonalBalances deleteAt ([_savedSideKey, _uid] call FLO_fnc_resourcePersonalKey);
    };

    private _changedRoleSides = [_uid] call FLO_fnc_commandClearUidRoles;

    if (_changedRoleSides isNotEqualTo []) then {
        FLO_CommandRevision = FLO_CommandRevision + 1;

        {
            [[west, east] select (_x isEqualTo "EAST")] call FLO_fnc_commandScheduleBroadcastSide;
        } forEach _changedRoleSides;
    };

    [_unit] call FLO_fnc_commandApplyPlayerRoles;

    _unit setVariable ["FLO_Spawn_Assigned", false, true];
    _unit setVariable ["FLO_Spawn_AssignedCellId", "", true];
    _unit setVariable ["FLO_Persistence_Loaded", false, true];
    _unit setVariable ["FLO_Spawn_ResetBeforeAssignment", true];

    ["playerSideChange"] call FLO_fnc_persistenceScheduleSave;

    if (_owner > 0) then {
        private _pendingAccess = createHashMapFromArray [
            ["owner", _owner],
            ["sideKey", _currentSideKey],
            ["player", _unit]
        ];
        private _pendingPayload = createHashMapFromArray [
            ["success", true],
            ["pendingVehicles", [_pendingAccess] call FLO_fnc_storePendingVehiclesForAccess],
            ["pendingApprovals", [_pendingAccess] call FLO_fnc_storePendingApprovalsForAccess]
        ];

        [_owner, "store::pendingVehicles", _pendingPayload] call FLO_fnc_storeSendResponse;
    };

    diag_log format [
        "[FLO][Persistence] Cleared saved player state uid=%1 savedSide=%2 currentSide=%3 pendingVehiclesRemoved=%4 pendingApprovalsRemoved=%5",
        _uid,
        _savedSideKey,
        _currentSideKey,
        _oldPendingCount - count FLO_StorePendingVehicles,
        _oldApprovalCount - count FLO_StorePendingApprovals
    ];

    false
};

private _assignedCellId = "";

if ("assignedCellId" in _record) then {
    _assignedCellId = _record get "assignedCellId";
};

if (_assignedCellId isEqualTo "") exitWith {
    diag_log format [
        "[FLO][Persistence] Ignored saved player state uid=%1 because it has no assigned deployment cell",
        _uid
    ];

    false
};

if (("damage" in _record) && {(_record get "damage") >= 1}) exitWith {
    diag_log format [
        "[FLO][Persistence] Ignored saved player state uid=%1 because saved damage is lethal",
        _uid
    ];

    false
};

if ("loadout" in _record) then {
    _unit setUnitLoadout (_record get "loadout");
};

if ("posASL" in _record) then {
    _unit setPosASL (_record get "posASL");
};

if (("vectorDir" in _record) && {"vectorUp" in _record}) then {
    _unit setVectorDirAndUp [_record get "vectorDir", _record get "vectorUp"];
} else {
    if ("dir" in _record) then {
        _unit setDir (_record get "dir");
    };
};

if ("damage" in _record) then {
    _unit setDamage (_record get "damage");
};

_unit setVariable ["FLO_Spawn_Assigned", true, true];
_unit setVariable ["FLO_Persistence_Loaded", true, true];

if ("assignedCellId" in _record) then {
    _unit setVariable ["FLO_Spawn_AssignedCellId", _assignedCellId, true];
};

[_unit, _recordData] call FLO_fnc_persistenceSyncPlayerState;

diag_log format [
    "[FLO][Persistence] Queued saved player state sync uid=%1 owner=%2",
    _uid,
    owner _unit
];

true
