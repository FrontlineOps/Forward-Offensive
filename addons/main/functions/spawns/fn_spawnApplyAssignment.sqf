params ["_spawnASL", "_dir", "_sideKey", "_cellId"];

if (!hasInterface) exitWith {};
if (isMultiplayer && {remoteExecutedOwner isNotEqualTo 2}) exitWith {};
if (isNull player) exitWith {};

player setPosASL _spawnASL;
player setDir _dir;
player setVariable ["FLO_Spawn_Assigned", true];
player setVariable ["FLO_Spawn_AssignedCellId", _cellId];

hint format ["Deployed to %1 staging area.", _sideKey];
