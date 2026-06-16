params ["_fob", "_side", ["_ownerUid", ""], ["_forcedId", ""], ["_buildRadius", -1], ["_baseType", "FOB"]];

if (!isServer) exitWith {};
if (isNull _fob) then {
    throw "[FLO][FOB] Cannot register null FOB";
};

private _config = [_baseType] call FLO_fnc_fobTypeConfig;
private _type = _config get "type";
private _label = _config get "label";
private _sideKey = [_side] call FLO_fnc_resourceSideKey;
private _id = _forcedId;

if (_id isEqualTo "") then {
    _id = format ["%1_%2_%3", _sideKey, _type, FLO_FOBNextId];
    FLO_FOBNextId = FLO_FOBNextId + 1;
};

if (_buildRadius < 0) then {
    _buildRadius = _config get "buildRadius";
};

private _markerId = format ["FLO_FOB_%1", _id];
private _marker = createMarker [_markerId, getPos _fob];
_marker setMarkerShapeLocal "ICON";
_marker setMarkerTypeLocal (["b_installation", "o_installation"] select (_side isEqualTo east));
_marker setMarkerColorLocal (["ColorWEST", "ColorEAST"] select (_side isEqualTo east));
_marker setMarkerText format ["%1 %2", ["BLUFOR", "OPFOR"] select (_side isEqualTo east), _label];

_fob setVariable ["FLO_FOB_Id", _id, true];
_fob setVariable ["FLO_FOB_Type", _type, true];
_fob setVariable ["FLO_FOB_SideKey", _sideKey, true];
_fob setVariable ["FLO_FOB_BuildRadius", _buildRadius, true];
_fob setVariable ["FLO_FOB_OwnerUid", _ownerUid, true];
_fob setVariable ["FLO_FOB_LogisticsCategories", +(_config get "logisticsCategories"), true];
_fob setVariable ["FLO_FOB_StoreEnabled", _config get "storeEnabled", true];
_fob setVariable ["FLO_FOB_VehicleStoreEnabled", _config get "vehicleStoreEnabled", true];
_fob setVariable ["FLO_FOB_TicketStoreEnabled", _config get "ticketStoreEnabled", true];
_fob setVariable ["FLO_FOB_RespawnEnabled", _config get "respawnEnabled", true];
_fob setVariable ["FLO_FOB_EnemyDisableRadius", _config get "enemyDisableRadius", true];

FLO_FOBs set [
    _id,
    createHashMapFromArray [
        ["id", _id],
        ["type", _type],
        ["object", _fob],
        ["side", _side],
        ["sideKey", _sideKey],
        ["ownerUid", _ownerUid],
        ["marker", _markerId],
        ["buildRadius", _buildRadius],
        ["logisticsCategories", +(_config get "logisticsCategories")],
        ["storeEnabled", _config get "storeEnabled"],
        ["vehicleStoreEnabled", _config get "vehicleStoreEnabled"],
        ["ticketStoreEnabled", _config get "ticketStoreEnabled"],
        ["respawnEnabled", _config get "respawnEnabled"],
        ["respawnHandle", []],
        ["enemyDisableRadius", _config get "enemyDisableRadius"],
        ["createdAt", diag_tickTime]
    ]
];

[_fob] remoteExecCall ["FLO_fnc_fobAddClientAction", 0, _fob];
[_id] call FLO_fnc_fobSyncRespawn;

_fob addEventHandler [
    "Killed",
    {
        params ["_unit"];

        private _id = _unit getVariable ["FLO_FOB_Id", ""];

        if (_id isNotEqualTo "") then {
            private _type = _unit getVariable ["FLO_FOB_Type", "FOB"];
            [_id, false, true] call FLO_fnc_fobUnregister;
            diag_log format ["[FLO][FOB] %1 %2 destroyed", _type, _id];
        };
    }
];

_id
