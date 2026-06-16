params ["_side"];

if (!isServer) exitWith {};
if !(_side in [west, east]) exitWith {};

private _sideKey = [_side] call FLO_fnc_objectiveSideKey;
private _activeBaseRespawns = {
    private _record = FLO_FOBs get _x;
    ((_record get "side") isEqualTo _side) && {(_record get "respawnHandle") isNotEqualTo []}
} count keys FLO_FOBs;
private _stagingHandle = FLO_SpawnStagingRespawnHandles get _sideKey;

if (_activeBaseRespawns > 0) exitWith {
    if (_stagingHandle isNotEqualTo []) then {
        _stagingHandle call BIS_fnc_removeRespawnPosition;
        FLO_SpawnStagingRespawnHandles set [_sideKey, []];

        diag_log format ["[FLO][Spawn] Removed %1 staging respawn; active base respawns=%2", _sideKey, _activeBaseRespawns];
    };
};

if (_stagingHandle isNotEqualTo []) exitWith {};

private _zone = FLO_DeploymentZones get _sideKey;
private _cellId = _zone get "cellId";
private _cell = FLO_ObjectiveCells get _cellId;
private _spawnATL = [_cell, 0, "B_Soldier_F", true] call FLO_fnc_spawnFindLandPositionInCell;
private _label = format ["%1 Staging", ["BLUFOR", "OPFOR"] select (_side isEqualTo east)];

FLO_SpawnStagingRespawnHandles set [_sideKey, [_side, _spawnATL, _label] call BIS_fnc_addRespawnPosition];

diag_log format [
    "[FLO][Spawn] Added %1 staging respawn cell=%2 pos=%3",
    _sideKey,
    _cellId,
    _spawnATL
];
