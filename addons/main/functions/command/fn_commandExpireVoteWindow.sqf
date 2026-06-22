params ["_sideKey", "_kind", "_promptId"];

if (!isServer) exitWith {};

private _state = FLO_CommandSideState get _sideKey;
private _side = [west, east] select (_sideKey isEqualTo "EAST");
private _resolved = false;

switch (_kind) do {
    case "commander": {
        if !(_state get "commanderVoteOpen") exitWith {};
        if ((_state get "commanderVotePromptId") isNotEqualTo _promptId) exitWith {};

        _resolved = [_side, true, true] call FLO_fnc_commandResolveCommanderVote;

        if (!_resolved) then {
            _state set ["commanderVoteOpen", false];
            _state set ["commanderVoteReason", ""];
            _state set ["commanderVoteEndsAt", 0];
            _state set ["commanderVotePromptId", ""];
            FLO_CommandRevision = FLO_CommandRevision + 1;

            diag_log format [
                "[FLO][Command] %1 commander vote expired without a valid winner",
                _sideKey
            ];
        };
    };
    case "faction": {
        if !(_state get "factionVoteOpen") exitWith {};
        if ((_state get "factionVotePromptId") isNotEqualTo _promptId) exitWith {};

        _resolved = [_side, true, true] call FLO_fnc_commandResolveFactionVote;

        if (!_resolved) then {
            _state set ["factionVoteOpen", false];
            _state set ["factionVoteReason", ""];
            _state set ["factionVoteEndsAt", 0];
            _state set ["factionVotePromptId", ""];
            FLO_CommandRevision = FLO_CommandRevision + 1;

            diag_log format [
                "[FLO][Command] %1 faction vote expired without a valid winner",
                _sideKey
            ];
        };
    };
};

[_side] call FLO_fnc_commandScheduleBroadcastSide;
