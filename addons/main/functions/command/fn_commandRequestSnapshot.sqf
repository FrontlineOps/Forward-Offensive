params ["_player", ["_attempt", 0, [0]], ["_requestOwner", remoteExecutedOwner, [0]]];

if (!isServer) exitWith {};
if (isNull _player) exitWith {};

private _owner = owner _player;
private _side = side group _player;

if ((_requestOwner > 2) && {_owner isNotEqualTo _requestOwner}) exitWith {
    if (_attempt < 20) exitWith {
        [
            {
                params ["_player", "_attempt", "_requestOwner"];
                [_player, _attempt + 1, _requestOwner] call FLO_fnc_commandRequestSnapshot;
            },
            [_player, _attempt, _requestOwner],
            0.5
        ] call CBA_fnc_waitAndExecute;
    };

    diag_log format [
        "[FLO][Command] Rejected command snapshot request from owner %1 for owner %2",
        _requestOwner,
        _owner
    ];
};

if !(_side in [west, east]) exitWith {
    if (_attempt < 20) exitWith {
        [
            {
                params ["_player", "_attempt", "_requestOwner"];
                [_player, _attempt + 1, _requestOwner] call FLO_fnc_commandRequestSnapshot;
            },
            [_player, _attempt, _requestOwner],
            0.5
        ] call CBA_fnc_waitAndExecute;
    };
};

private _requestKey = str ([_owner, _requestOwner] select (_requestOwner > 2));
private _now = diag_tickTime;

if (_requestKey in FLO_CommandSnapshotRequestTimes) then {
    if ((_now - (FLO_CommandSnapshotRequestTimes get _requestKey)) < 0.25) exitWith {};
};

FLO_CommandSnapshotRequestTimes set [_requestKey, _now];

if ([_side] call FLO_fnc_commandEnsureInitialVoteWindow) then {
    [_side] call FLO_fnc_commandScheduleBroadcastSide;
};

[_player] call FLO_fnc_commandSendSnapshot;
