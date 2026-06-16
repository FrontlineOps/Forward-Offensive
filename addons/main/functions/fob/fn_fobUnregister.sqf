params ["_id", ["_deleteObject", false], ["_scheduleSave", true]];

if (!isServer) exitWith {};
if !(_id in FLO_FOBs) exitWith {};

private _record = FLO_FOBs get _id;

[_record] call FLO_fnc_fobRemoveRespawn;
deleteMarker (_record get "marker");

private _object = _record get "object";

if (_deleteObject && {!isNull _object}) then {
    deleteVehicle _object;
};

FLO_FOBs deleteAt _id;

if (_scheduleSave) then {
    ["baseUnregister"] call FLO_fnc_persistenceScheduleSave;
};
