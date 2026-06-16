params ["_recordData"];

if (!hasInterface) exitWith {};

if (isMultiplayer && {remoteExecutedOwner isNotEqualTo 2} && {remoteExecutedOwner isNotEqualTo 0}) exitWith {
    diag_log format ["[FLO][Persistence] Rejected player state from owner %1", remoteExecutedOwner];
};

private _record = createHashMapFromArray _recordData;

if ((_record get "uid") isNotEqualTo (getPlayerUID player)) exitWith {};

if ("loadout" in _record) then {
    player setUnitLoadout (_record get "loadout");
};

if ("posASL" in _record) then {
    player setPosASL (_record get "posASL");
};

if (("vectorDir" in _record) && {"vectorUp" in _record}) then {
    player setVectorDirAndUp [_record get "vectorDir", _record get "vectorUp"];
} else {
    if ("dir" in _record) then {
        player setDir (_record get "dir");
    };
};

if ("damage" in _record) then {
    player setDamage (_record get "damage");
};

if ("assignedCellId" in _record) then {
    player setVariable ["FLO_Spawn_AssignedCellId", _record get "assignedCellId", true];
};

player setVariable ["FLO_Persistence_Loaded", true, true];

diag_log format [
    "[FLO][Persistence] Applied saved player state uid=%1 cell=%2",
    _record get "uid",
    _record get "assignedCellId"
];
