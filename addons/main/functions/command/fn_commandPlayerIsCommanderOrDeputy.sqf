params ["_player"];

if (isNull _player) exitWith { false };

private _side = side group _player;

if !(_side in [west, east]) exitWith { false };

private _sideKey = [_side] call FLO_fnc_resourceSideKey;
private _uid = getPlayerUID _player;

if (_uid isEqualTo "") exitWith { false };

if (isServer) exitWith {
    private _state = FLO_CommandSideState get _sideKey;

    if ((_state get "commanderUid") isEqualTo _uid) exitWith { true };

    private _roles = _state get "roleAssignments";
    _uid in (_roles get "deputy")
};

if (!hasInterface) exitWith { false };
if !("sideKey" in FLO_CommandSnapshot) exitWith { false };
if ((FLO_CommandSnapshot get "sideKey") isNotEqualTo _sideKey) exitWith { false };

(FLO_CommandSnapshot get "playerIsCommander") || {FLO_CommandSnapshot get "playerIsDeputy"}
