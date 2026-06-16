if (!hasInterface) exitWith { false };
if !((side group player) in [west, east]) exitWith {
    hint "Command voting is only available to BLUFOR and OPFOR.";
    false
};

private _display = findDisplay FLO_CommandVoteDialogIdd;

if (!isNull _display) exitWith {
    if ("sideKey" in FLO_CommandSnapshot) then {
        [] call FLO_fnc_commandUpdateVoteDialog;
    } else {
        [player] remoteExecCall ["FLO_fnc_commandRequestSnapshot", 2];
    };

    true
};

createDialog "FLO_CommandVoteDialog";
_display = findDisplay FLO_CommandVoteDialogIdd;

if (isNull _display) exitWith { false };

FLO_CommandVoteBrowserReady = false;
FLO_CommandVoteRenderKey = "";

private _control = _display displayCtrl FLO_CommandVoteBrowserIdc;
uiNamespace setVariable ["FLO_CommandVoteControl", _control];

[_control] call FLO_fnc_commandAddWebEventHandler;

[_control, ["LoadFile", "\z\foof\addons\main\ui\command\index.html"]] call FLO_fnc_commandWebAction;

if !("sideKey" in FLO_CommandSnapshot) then {
    [player] remoteExecCall ["FLO_fnc_commandRequestSnapshot", 2];
};

true
