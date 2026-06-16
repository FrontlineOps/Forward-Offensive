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

if ("assignedCellId" in _record) then {
    _unit setVariable ["FLO_Spawn_AssignedCellId", _assignedCellId, true];
};

if (_owner <= 0) then {
    _owner = owner _unit;
};

if (_owner <= 0) exitWith {
    if (hasInterface && {(getPlayerUID player) isEqualTo _uid}) then {
        [_recordData] call FLO_fnc_persistenceApplyPlayerState;
    };

    true
};

[_recordData] remoteExecCall ["FLO_fnc_persistenceApplyPlayerState", _owner];

diag_log format [
    "[FLO][Persistence] Sent saved player state uid=%1 owner=%2",
    _uid,
    _owner
];

true
