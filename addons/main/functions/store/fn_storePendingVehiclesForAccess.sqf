params ["_access"];

private _owner = _access get "owner";
private _sideKey = _access get "sideKey";
private _playerUid = getPlayerUID (_access get "player");
private _now = diag_tickTime;
private _pending = [];
private _kept = [];

{
    private _createdAt = _x get "createdAt";
    private _expired = (_now - _createdAt) > FLO_StorePendingVehicleTtl;

    if (!_expired) then {
        _kept pushBack _x;

        if (((_x get "sideKey") isEqualTo _sideKey) && {((_x get "owner") isEqualTo _owner) || {(_x get "playerUid") isEqualTo _playerUid}}) then {
            _pending pushBack createHashMapFromArray [
                ["id", _x get "id"],
                ["className", _x get "className"],
                ["name", _x get "name"],
                ["category", _x get "category"],
                ["fobNetId", _x get "fobNetId"]
            ];
        };
    };
} forEach FLO_StorePendingVehicles;

if ((count _kept) isNotEqualTo (count FLO_StorePendingVehicles)) then {
    ["storePendingExpired"] call FLO_fnc_persistenceScheduleSave;
};

FLO_StorePendingVehicles = _kept;

_pending
