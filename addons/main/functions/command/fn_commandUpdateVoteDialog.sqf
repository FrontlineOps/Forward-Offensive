if (!hasInterface) exitWith {};

private _control = uiNamespace getVariable ["FLO_CommandVoteControl", controlNull];

if (isNull _control) exitWith {};
if !("sideKey" in FLO_CommandSnapshot) exitWith {};
if (!FLO_CommandVoteBrowserReady) exitWith {};

private _renderKey = format [
    "%1|%2|%3|%4|%5|%6|%7",
    FLO_CommandSnapshot get "revision",
    FLO_CommandSnapshot get "votePromptId",
    FLO_CommandSnapshot get "playerCommanderVote",
    FLO_CommandSnapshot get "playerFactionVote",
    FLO_CommandSnapshot get "playerIsCommander",
    FLO_CommandSnapshot get "playerCount",
    FLO_CommandSnapshot get "shouldPromptVote"
];

if (FLO_CommandVoteRenderKey isEqualTo _renderKey) exitWith {};
FLO_CommandVoteRenderKey = _renderKey;

private _script = format [
    "if (window.FOOFCommand) { window.FOOFCommand.applySnapshot(%1); }",
    toJSON FLO_CommandSnapshot
];

[_control, ["ExecJS", _script]] call FLO_fnc_commandWebAction;
