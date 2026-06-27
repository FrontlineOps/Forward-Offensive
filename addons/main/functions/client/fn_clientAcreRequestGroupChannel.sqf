params ["_player", ["_requestOwner", remoteExecutedOwner, [0]]];

if (!isServer) exitWith {};
if (isNull _player) exitWith {};

private _owner = owner _player;
if ((_requestOwner > 2) && {_owner isNotEqualTo _requestOwner}) exitWith {
    diag_log format [
        "[FLO][ACRE] Rejected group channel request from owner %1 for player owner %2",
        _requestOwner,
        _owner
    ];
};

private _group = group _player;
private _side = side _group;
if !(_side in [west, east]) exitWith {};

private _existing = _group getVariable ["FLO_AcreShortRangeChannel", 0];
if (_existing >= 1 && {_existing <= 10}) exitWith {};

private _sideKey = switch (_side) do {
    case west: { "WEST" };
    case east: { "EAST" };
};

private _next = FLO_AcreNextGroupChannel get _sideKey;

_group setVariable ["FLO_AcreShortRangeChannel", _next, true];

private _nextChannel = _next + 1;
if (_nextChannel > 10) then {
    _nextChannel = 1;
};
FLO_AcreNextGroupChannel set [_sideKey, _nextChannel];
