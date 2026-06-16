params ["_side", ["_allowPlurality", false, [false]]];

if (!isServer) exitWith { false };

private _sideKey = [_side] call FLO_fnc_resourceSideKey;
private _state = FLO_CommandSideState get _sideKey;
private _players = [_side] call FLO_fnc_commandSidePlayers;
private _votes = _state get "commanderVotes";
private _activeUids = createHashMap;

{
    _activeUids set [getPlayerUID _x, _x];
} forEach _players;

{
    if !(_x in _activeUids) then {
        _votes deleteAt _x;
    };
} forEach keys _votes;

private _requiredVotes = (floor ((count _players) / 2)) + 1;
private _voteCounts = createHashMap;

{
    private _candidateUid = _y;

    if (_candidateUid in _activeUids) then {
        private _count = 0;
        if (_candidateUid in _voteCounts) then {
            _count = _voteCounts get _candidateUid;
        };

        _voteCounts set [_candidateUid, _count + 1];
    };
} forEach _votes;

private _winnerUid = "";
private _winnerVotes = 0;
private _winnerTied = false;

{
    if (_y > _winnerVotes) then {
        _winnerUid = _x;
        _winnerVotes = _y;
        _winnerTied = false;
    } else {
        if (_y isEqualTo _winnerVotes) then {
            _winnerTied = true;
        };
    };
} forEach _voteCounts;

if (_winnerUid isEqualTo "") exitWith { false };
if ((_winnerVotes < _requiredVotes) && {!_allowPlurality || {_winnerTied}}) exitWith { false };

private _winner = _activeUids get _winnerUid;
_state set ["commanderUid", _winnerUid];
_state set ["commanderName", name _winner];
_state set ["commanderVoteOpen", false];
_state set ["commanderVoteReason", ""];
_state set ["commanderVoteEndsAt", 0];
_state set ["commanderVotePromptId", ""];

FLO_CommandRevision = FLO_CommandRevision + 1;
["commanderResolved"] call FLO_fnc_persistenceScheduleSave;

diag_log format [
    "[FLO][Command] %1 commander elected uid=%2 name=%3 votes=%4 required=%5 plurality=%6",
    _sideKey,
    _winnerUid,
    name _winner,
    _winnerVotes,
    _requiredVotes,
    _allowPlurality
];

true
