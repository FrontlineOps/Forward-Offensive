params ["_side", ["_allowPlurality", false, [false]]];

if (!isServer) exitWith { false };

private _sideKey = [_side] call FLO_fnc_resourceSideKey;
private _state = FLO_CommandSideState get _sideKey;
private _players = [_side] call FLO_fnc_commandSidePlayers;
private _votes = _state get "factionVotes";
private _activeUids = createHashMap;
private _optionsByClass = createHashMap;

{
    _activeUids set [getPlayerUID _x, true];
} forEach _players;

{
    _optionsByClass set [_x get "class", _x];
} forEach (FLO_CommandFactionOptions get _sideKey);

{
    if !(_x in _activeUids) then {
        _votes deleteAt _x;
    };
} forEach keys _votes;

private _requiredVotes = (floor ((count _players) / 2)) + 1;
private _voteCounts = createHashMap;

{
    private _factionClass = _y;

    if (_factionClass in _optionsByClass) then {
        private _count = 0;
        if (_factionClass in _voteCounts) then {
            _count = _voteCounts get _factionClass;
        };

        _voteCounts set [_factionClass, _count + 1];
    };
} forEach _votes;

private _winnerClass = "";
private _winnerVotes = 0;
private _winnerTied = false;

{
    if (_y > _winnerVotes) then {
        _winnerClass = _x;
        _winnerVotes = _y;
        _winnerTied = false;
    } else {
        if (_y isEqualTo _winnerVotes) then {
            _winnerTied = true;
        };
    };
} forEach _voteCounts;

if (_winnerClass isEqualTo "") exitWith { false };
if ((_winnerVotes < _requiredVotes) && {!_allowPlurality || {_winnerTied}}) exitWith { false };

private _winner = _optionsByClass get _winnerClass;
_state set ["factionClass", _winnerClass];
_state set ["factionName", _winner get "displayName"];
_state set ["factionVoteOpen", false];
_state set ["factionVoteReason", ""];
_state set ["factionVoteEndsAt", 0];
_state set ["factionVotePromptId", ""];

FLO_CommandRevision = FLO_CommandRevision + 1;
["factionResolved"] call FLO_fnc_persistenceScheduleSave;

diag_log format [
    "[FLO][Command] %1 faction selected class=%2 name=%3 votes=%4 required=%5 plurality=%6",
    _sideKey,
    _winnerClass,
    _winner get "displayName",
    _winnerVotes,
    _requiredVotes,
    _allowPlurality
];

true
