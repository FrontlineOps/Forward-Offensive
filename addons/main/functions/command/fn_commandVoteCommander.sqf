params ["_player", ["_candidateUid", "", [""]]];

if (!isServer) exitWith {};
if (isNull _player) exitWith {};

private _owner = owner _player;

if ((remoteExecutedOwner > 2) && {_owner isNotEqualTo remoteExecutedOwner}) exitWith {
    diag_log format [
        "[FLO][Command] Rejected commander vote from owner %1 for owner %2",
        remoteExecutedOwner,
        _owner
    ];
};

private _side = side group _player;

if !(_side in [west, east]) exitWith {};
if (_candidateUid isEqualTo "") exitWith {};

private _sideKey = [_side] call FLO_fnc_resourceSideKey;
private _state = FLO_CommandSideState get _sideKey;

if !(_state get "commanderVoteOpen") exitWith {
    [_player] call FLO_fnc_commandSendSnapshot;
};

if (diag_tickTime >= (_state get "commanderVoteEndsAt")) exitWith {
    [_sideKey, "commander", _state get "commanderVotePromptId"] call FLO_fnc_commandExpireVoteWindow;
};

private _validCandidate = (([_side] call FLO_fnc_commandSidePlayers) findIf {
    (getPlayerUID _x) isEqualTo _candidateUid
}) isNotEqualTo -1;

if (!_validCandidate) exitWith {
    [_player] call FLO_fnc_commandSendSnapshot;
};

private _votes = _state get "commanderVotes";
private _playerUid = getPlayerUID _player;
private _currentVote = "";

if (_playerUid in _votes) then {
    _currentVote = _votes get _playerUid;
};

if (_currentVote isEqualTo _candidateUid) exitWith {
    [_player] call FLO_fnc_commandSendSnapshot;
};

_votes set [_playerUid, _candidateUid];

FLO_CommandRevision = FLO_CommandRevision + 1;
[_side] call FLO_fnc_commandResolveCommanderVote;
[_player] call FLO_fnc_commandSendSnapshot;
[_side] call FLO_fnc_commandScheduleBroadcastSide;
