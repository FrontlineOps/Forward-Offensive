params ["_className", "_position", "_direction", "_sideKey", "_fob"];

if (!isServer) exitWith { objNull };

private _vehicle = createVehicle [_className, _position, [], 0, "NONE"];
_vehicle setDir _direction;
_vehicle setPosATL _position;
_vehicle setVariable ["FLO_Store_PurchasedSideKey", _sideKey, true];
_vehicle setVariable ["FLO_Store_SourceFobId", _fob getVariable ["FLO_FOB_Id", ""], true];
_vehicle lock 0;
["storeVehicleSpawn"] call FLO_fnc_persistenceScheduleSave;

_vehicle
