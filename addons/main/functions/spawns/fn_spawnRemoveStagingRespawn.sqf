params ["_side"];

if (!isServer) exitWith {};

private _sideKey = [_side] call FLO_fnc_objectiveSideKey;
private _handle = FLO_SpawnStagingRespawnHandles get _sideKey;

if (_handle isEqualTo []) exitWith {};

_handle call BIS_fnc_removeRespawnPosition;
FLO_SpawnStagingRespawnHandles set [_sideKey, []];

diag_log format ["[FLO][Spawn] Removed %1 staging respawn", _sideKey];
