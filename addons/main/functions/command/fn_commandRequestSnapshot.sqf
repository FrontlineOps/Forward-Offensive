params ["_player"];

if (!isServer) exitWith {};
if (isNull _player) exitWith {};

private _owner = owner _player;
private _side = side group _player;

if ((remoteExecutedOwner > 2) && {_owner isNotEqualTo remoteExecutedOwner}) exitWith {
    diag_log format [
        "[FLO][Command] Rejected command snapshot request from owner %1 for owner %2",
        remoteExecutedOwner,
        _owner
    ];
};

if !(_side in [west, east]) exitWith {};

private _requestKey = str _owner;
private _now = diag_tickTime;

if (_requestKey in FLO_CommandSnapshotRequestTimes) then {
    if ((_now - (FLO_CommandSnapshotRequestTimes get _requestKey)) < 0.25) exitWith {};
};

FLO_CommandSnapshotRequestTimes set [_requestKey, _now];

[_side] call FLO_fnc_commandEnsureInitialVoteWindow;
[_player] call FLO_fnc_commandSendSnapshot;
