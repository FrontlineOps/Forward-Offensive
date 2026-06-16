params ["_player", ["_schedule", true, [false]]];

if (!isServer) exitWith { [] };
if (isNull _player) exitWith { [] };

private _uid = getPlayerUID _player;

if (_uid isEqualTo "") exitWith { [] };

private _sideKey = [side group _player] call FLO_fnc_persistenceSideKey;
private _assignedCellId = _player getVariable ["FLO_Spawn_AssignedCellId", ""];
private _vehicleNetId = "";

if ((vehicle _player) isNotEqualTo _player) then {
    _vehicleNetId = netId (vehicle _player);
};

private _record = [
    ["uid", _uid],
    ["name", name _player],
    ["sideKey", _sideKey],
    ["posASL", getPosASL _player],
    ["dir", getDir _player],
    ["vectorDir", vectorDir _player],
    ["vectorUp", vectorUp _player],
    ["damage", damage _player],
    ["loadout", getUnitLoadout _player],
    ["assignedCellId", _assignedCellId],
    ["vehicleNetId", _vehicleNetId],
    ["savedAt", systemTimeUTC]
];

FLO_PersistencePlayerRecords set [_uid, _record];

if (_schedule) then {
    ["player"] call FLO_fnc_persistenceScheduleSave;
};

_record
