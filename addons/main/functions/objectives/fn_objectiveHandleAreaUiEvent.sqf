params ["_control", "_isConfirmDialog", "_message"];

private _eventData = fromJSON _message;
private _event = _eventData get "event";

switch (_event) do {
    case "objective::ready": {
        uiNamespace setVariable ["FLO_ObjectiveAreaControl", _control];
        FLO_ObjectiveAreaBrowserReady = true;
        [] call FLO_fnc_objectiveUpdateAreaDialog;
    };
    case "objective::upgrade": {
        [player, FLO_ObjectiveAreaActiveId] remoteExecCall ["FLO_fnc_objectiveRequestUpgrade", 2];
    };
    case "objective::close": {
        FLO_ObjectiveAreaClosedId = FLO_ObjectiveAreaActiveId;
        closeDialog 0;
    };
    default {
        diag_log format ["[FLO][Objective] Unhandled objective area UI event: %1", _event];
    };
};

true
