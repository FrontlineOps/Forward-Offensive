params ["_player", ["_attempt", 0], ["_requestOwner", remoteExecutedOwner]];

if (!isServer) exitWith {};
if (isNull _player) exitWith {};

private _owner = owner _player;

if ((_requestOwner > 2) && {_owner isNotEqualTo _requestOwner}) exitWith {
    if ((_owner <= 2) && {_attempt < 20}) exitWith {
        [
            {
                params ["_player", "_attempt", "_requestOwner"];
                [_player, _attempt + 1, _requestOwner] call FLO_fnc_spawnRequestAssignment;
            },
            [_player, _attempt, _requestOwner],
            0.5
        ] call CBA_fnc_waitAndExecute;
    };

    diag_log format [
        "[FLO][Spawn] Rejected spawn assignment request from owner %1 for owner %2",
        _requestOwner,
        _owner
    ];
};

private _side = side group _player;

if !(_side in [west, east]) exitWith {
    if (_attempt < 20) exitWith {
        [
            {
                params ["_player", "_attempt", "_requestOwner"];
                [_player, _attempt + 1, _requestOwner] call FLO_fnc_spawnRequestAssignment;
            },
            [_player, _attempt, _requestOwner],
            0.5
        ] call CBA_fnc_waitAndExecute;
    };
};

private _ticketBalance = [_side] call FLO_fnc_ticketSideBalance;
private _ticketLocked = _ticketBalance <= 0;

[_player, _ticketLocked, ""] call FLO_fnc_ticketSyncPlayer;

private _uid = getPlayerUID _player;

if ((_uid isNotEqualTo "") && {_uid in FLO_PersistencePlayerRecords}) exitWith {
    [_uid, _owner] call FLO_fnc_persistenceApplyPlayerToOwner;

    diag_log format [
        "[FLO][Spawn] Restored persisted state for %1 player %2 instead of assigning deployment slot",
        [_side] call FLO_fnc_objectiveSideKey,
        name _player
    ];
};

private _sideKey = [_side] call FLO_fnc_objectiveSideKey;
private _zone = FLO_DeploymentZones get _sideKey;
private _slot = FLO_SpawnSideAssignmentCounts get _sideKey;
FLO_SpawnSideAssignmentCounts set [_sideKey, _slot + 1];

private _baseASL = _zone get "spawnASL";
private _baseATL = ASLToATL _baseASL;
private _radius = 0;
private _angle = 0;

if (_slot > 0) then {
    _radius = 8 + (floor ((_slot - 1) / 8)) * 8;
    _angle = ((_slot - 1) mod 8) * 45;
};

private _spawnATL = [
    (_baseATL # 0) + ((sin _angle) * _radius),
    (_baseATL # 1) + ((cos _angle) * _radius),
    0
];
private _spawnASL = ATLToASL _spawnATL;
private _dir = _zone get "dir";

_player setVariable ["FLO_Spawn_AssignedCellId", _zone get "cellId", true];

[_spawnASL, _dir, _sideKey, _zone get "cellId"] remoteExecCall ["FLO_fnc_spawnApplyAssignment", _owner];

diag_log format [
    "[FLO][Spawn] Assigned %1 player %2 to deployment cell %3 slot=%4",
    _sideKey,
    name _player,
    _zone get "cellId",
    _slot
];
