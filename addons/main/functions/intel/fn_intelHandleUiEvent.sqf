params ["_control", "_isConfirmDialog", "_message"];

private _eventData = fromJSON _message;
private _event = _eventData get "event";

switch (_event) do {
    case "intel::ready": {
        uiNamespace setVariable ["FLO_IntelControl", _control];
        FLO_IntelBrowserReady = true;
        [] call FLO_fnc_intelUpdateDialog;
    };
    case "intel::search": {
        [player, FLO_IntelActiveBodyNetId] remoteExecCall ["FLO_fnc_intelRequestSearch", 2];
    };
    case "intel::close": {
        closeDialog 0;
    };
    default {
        diag_log format ["[FLO][Intel] Unhandled intel UI event: %1", _event];
    };
};

true
