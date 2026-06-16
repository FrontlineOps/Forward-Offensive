params ["_spawnASL", "_dir", "_sideKey", "_cellId"];

if (!hasInterface) exitWith {};
if (isMultiplayer && {remoteExecutedOwner isNotEqualTo 2}) exitWith {};
if (isNull player) exitWith {};

FLO_SpawnClientAssigned = true;

player setPosASL _spawnASL;
player setDir _dir;
player setVariable ["FLO_Spawn_Assigned", true];
player setVariable ["FLO_Spawn_AssignedCellId", _cellId];

[format ["Deployed to %1 staging area.", _sideKey], "success", "Deployment"] call FLO_fnc_notify;
