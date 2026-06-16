params ["_id", ["_deleteObject", false], ["_scheduleSave", true]];

if (!isServer) exitWith {};
if !(_id in FLO_FOBs) exitWith {};

private _record = FLO_FOBs get _id;
private _markerId = _record get "marker";
private _side = _record get "side";

[_record] call FLO_fnc_fobRemoveRespawn;
[_markerId] remoteExecCall ["FLO_fnc_fobRemoveClientMarker", 0];
deleteMarker _markerId;

private _object = _record get "object";

if (_deleteObject && {!isNull _object}) then {
    deleteVehicle _object;
};

FLO_FOBs deleteAt _id;
[_side] call FLO_fnc_spawnEnsureSideRespawn;

if (_scheduleSave) then {
    ["baseUnregister"] call FLO_fnc_persistenceScheduleSave;
};
