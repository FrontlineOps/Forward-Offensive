params ["_player", ["_permission", "build", [""]]];

if (isNull _player) exitWith { false };

private _side = side group _player;

if !(_side in [west, east]) exitWith { false };

private _sideKey = [_side] call FLO_fnc_resourceSideKey;
private _uid = getPlayerUID _player;

if (_uid isEqualTo "") exitWith { false };

if (isServer) exitWith {
    private _state = FLO_CommandSideState get _sideKey;

    if ((_state get "commanderUid") isEqualTo _uid) exitWith { true };

    private _grants = _state get "permissionGrants";
    if !(_permission in _grants) exitWith { false };

    _uid in (_grants get _permission)
};

if (!hasInterface) exitWith { false };
if !("sideKey" in FLO_CommandSnapshot) exitWith { false };
if ((FLO_CommandSnapshot get "sideKey") isNotEqualTo _sideKey) exitWith { false };
if ((FLO_CommandSnapshot get "commanderUid") isEqualTo _uid) exitWith { true };

private _permissions = FLO_CommandSnapshot get "permissions";

if !(_permission in _permissions) exitWith { false };

_permissions get _permission
