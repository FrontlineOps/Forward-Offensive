params ["_player"];

private _side = side group _player;
private _sideKey = [_side] call FLO_fnc_resourceSideKey;
private _state = FLO_CommandSideState get _sideKey;
private _players = [_side] call FLO_fnc_commandSidePlayers;
private _playerUid = getPlayerUID _player;
private _commanderVotes = _state get "commanderVotes";
private _factionVotes = _state get "factionVotes";
private _commanderUid = _state get "commanderUid";
private _playerCommanderVote = "";
private _playerFactionVote = "";
private _now = diag_tickTime;
private _commanderVoteOpen = _state get "commanderVoteOpen";
private _factionVoteOpen = _state get "factionVoteOpen";
private _votePromptParts = [];

if (_commanderVoteOpen) then {
    _votePromptParts pushBack (_state get "commanderVotePromptId");
};

if (_factionVoteOpen) then {
    _votePromptParts pushBack (_state get "factionVotePromptId");
};

if (_playerUid in _commanderVotes) then {
    _playerCommanderVote = _commanderVotes get _playerUid;
};

if (_playerUid in _factionVotes) then {
    _playerFactionVote = _factionVotes get _playerUid;
};

private _candidates = [];

{
    private _candidateUid = getPlayerUID _x;
    private _voteCount = 0;

    {
        if (_y isEqualTo _candidateUid) then {
            _voteCount = _voteCount + 1;
        };
    } forEach _commanderVotes;

    _candidates pushBack createHashMapFromArray [
        ["uid", _candidateUid],
        ["name", name _x],
        ["votes", _voteCount],
        ["isSelf", _candidateUid isEqualTo _playerUid],
        ["isCommander", _candidateUid isEqualTo _commanderUid]
    ];
} forEach _players;

_candidates = [_candidates, [], { _x get "name" }, "ASCEND"] call BIS_fnc_sortBy;

private _factions = [];

{
    private _factionClass = _x get "class";
    private _voteCount = 0;

    {
        if (_y isEqualTo _factionClass) then {
            _voteCount = _voteCount + 1;
        };
    } forEach _factionVotes;

    _factions pushBack createHashMapFromArray [
        ["class", _factionClass],
        ["displayName", _x get "displayName"],
        ["unitCount", _x get "unitCount"],
        ["vehicleCount", _x get "vehicleCount"],
        ["groupCount", _x get "groupCount"],
        ["compatibility", _x get "compatibility"],
        ["votes", _voteCount],
        ["selected", _factionClass isEqualTo (_state get "factionClass")]
    ];
} forEach (FLO_CommandFactionOptions get _sideKey);

private _playerIsCommander = _commanderUid isEqualTo _playerUid;

createHashMapFromArray [
    ["revision", FLO_CommandRevision],
    ["sideKey", _sideKey],
    ["sideName", ["BLUFOR", "OPFOR"] select (_side isEqualTo east)],
    ["playerUid", _playerUid],
    ["playerIsCommander", _playerIsCommander],
    ["shouldPromptVote", _commanderVoteOpen || {_factionVoteOpen}],
    ["votePromptId", _votePromptParts joinString "|"],
    ["commanderVoteOpen", _commanderVoteOpen],
    ["commanderVoteReason", _state get "commanderVoteReason"],
    ["commanderVotePromptId", _state get "commanderVotePromptId"],
    ["commanderVoteSecondsRemaining", 0 max (ceil ((_state get "commanderVoteEndsAt") - _now))],
    ["commanderUid", _commanderUid],
    ["commanderName", _state get "commanderName"],
    ["playerCommanderVote", _playerCommanderVote],
    ["candidates", _candidates],
    ["factionVoteOpen", _factionVoteOpen],
    ["factionVoteReason", _state get "factionVoteReason"],
    ["factionVotePromptId", _state get "factionVotePromptId"],
    ["factionVoteSecondsRemaining", 0 max (ceil ((_state get "factionVoteEndsAt") - _now))],
    ["factionClass", _state get "factionClass"],
    ["factionName", _state get "factionName"],
    ["playerFactionVote", _playerFactionVote],
    ["factions", _factions],
    ["requiredVotes", (floor ((count _players) / 2)) + 1],
    ["playerCount", count _players],
    ["permissions", createHashMapFromArray [
        ["build", _playerIsCommander],
        ["fob", _playerIsCommander],
        ["garage", _playerIsCommander],
        ["logistics", _playerIsCommander],
        ["store", _playerIsCommander]
    ]]
]
