params ["_fob", "_side", ["_ownerUid", ""], ["_forcedId", ""], ["_buildRadius", FLO_FOBBuildRadius]];

if (!isServer) exitWith {};
if (isNull _fob) then {
    throw "[FLO][FOB] Cannot register null FOB";
};

private _sideKey = [_side] call FLO_fnc_resourceSideKey;
private _id = _forcedId;

if (_id isEqualTo "") then {
    _id = format ["%1_%2", _sideKey, FLO_FOBNextId];
    FLO_FOBNextId = FLO_FOBNextId + 1;
};

private _markerId = format ["FLO_FOB_%1", _id];
private _marker = createMarker [_markerId, getPos _fob];
_marker setMarkerShapeLocal "ICON";
_marker setMarkerTypeLocal (["b_installation", "o_installation"] select (_side isEqualTo east));
_marker setMarkerColorLocal (["ColorWEST", "ColorEAST"] select (_side isEqualTo east));
_marker setMarkerText format ["%1 FOB", ["BLUFOR", "OPFOR"] select (_side isEqualTo east)];

_fob setVariable ["FLO_FOB_Id", _id, true];
_fob setVariable ["FLO_FOB_SideKey", _sideKey, true];
_fob setVariable ["FLO_FOB_BuildRadius", _buildRadius, true];
_fob setVariable ["FLO_FOB_OwnerUid", _ownerUid, true];

FLO_FOBs set [
    _id,
    createHashMapFromArray [
        ["id", _id],
        ["object", _fob],
        ["side", _side],
        ["sideKey", _sideKey],
        ["ownerUid", _ownerUid],
        ["marker", _markerId],
        ["buildRadius", _buildRadius],
        ["createdAt", diag_tickTime]
    ]
];

[_fob] remoteExecCall ["FLO_fnc_fobAddClientAction", 0, _fob];

_fob addEventHandler [
    "Killed",
    {
        params ["_unit"];

        private _id = _unit getVariable ["FLO_FOB_Id", ""];

        if (_id isNotEqualTo "") then {
            private _record = FLO_FOBs get _id;
            deleteMarker (_record get "marker");
            FLO_FOBs deleteAt _id;

            ["fobDestroyed"] call FLO_fnc_persistenceScheduleSave;

            diag_log format ["[FLO][FOB] FOB %1 destroyed", _id];
        };
    }
];

_id
