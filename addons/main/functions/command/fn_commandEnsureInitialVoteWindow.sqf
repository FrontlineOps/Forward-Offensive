params ["_side"];

if (!isServer) exitWith {};

private _sideKey = [_side] call FLO_fnc_resourceSideKey;
private _state = FLO_CommandSideState get _sideKey;

if (_state get "initialVoteStarted") exitWith { false };

_state set ["initialVoteStarted", true];

[_sideKey, "commander", "initial", FLO_CommandInitialVoteDuration] call FLO_fnc_commandStartVoteWindow;
[_sideKey, "faction", "initial", FLO_CommandInitialVoteDuration] call FLO_fnc_commandStartVoteWindow;

diag_log format [
    "[FLO][Command] %1 initial command and faction vote window opened",
    _sideKey
];

true
