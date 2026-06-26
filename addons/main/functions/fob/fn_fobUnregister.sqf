params ["_id", ["_deleteObject", false], ["_scheduleSave", true]];

if (!isServer) exitWith {};
if !(_id in FLO_FOBs) exitWith {};

private _record = FLO_FOBs get _id;
private _markerId = _record get "marker";
private _side = _record get "side";
private _object = _record get "object";
private _actionJipId = _record get "actionJipId";

[_record] call FLO_fnc_fobRemoveRespawn;
if (_actionJipId isNotEqualTo "") then {
    remoteExec ["", _actionJipId];
};

[_markerId, _object] remoteExecCall ["FLO_fnc_fobRemoveClientMarker", 0];
deleteMarker _markerId;

if (_deleteObject && {!isNull _object}) then {
    deleteVehicle _object;
} else {
    if (!isNull _object) then {
        _object setVariable ["FLO_FOB_Id", "", true];
        _object setVariable ["FLO_FOB_Type", "", true];
        _object setVariable ["FLO_FOB_SideKey", "", true];
        _object setVariable ["FLO_FOB_BuildRadius", 0, true];
        _object setVariable ["FLO_FOB_StoreEnabled", false, true];
        _object setVariable ["FLO_FOB_VehicleStoreEnabled", false, true];
        _object setVariable ["FLO_FOB_RespawnEnabled", false, true];
    };
};

FLO_FOBs deleteAt _id;
[_side] call FLO_fnc_spawnEnsureSideRespawn;

if (_scheduleSave) then {
    ["baseUnregister"] call FLO_fnc_persistenceScheduleSave;
};
