params ["_payload"];

if (!hasInterface) exitWith {};

if (isMultiplayer && {remoteExecutedOwner isNotEqualTo 2} && {remoteExecutedOwner isNotEqualTo 0}) exitWith {
    diag_log format ["[FLO][Intel] Rejected intel result from owner %1", remoteExecutedOwner];
};

FLO_IntelLastPayload = _payload;

if ((_payload get "success") && {(_payload get "type") in ["base", "players"]}) then {
    [_payload] call FLO_fnc_intelCreateMarker;
};

[_payload] call FLO_fnc_intelUpdateDialog;

private _message = _payload get "message";
private _title = _payload get "title";
private _notificationType = if (_payload get "success") then {
    ["success", "warning"] select ((_payload get "type") isEqualTo "none");
} else {
    "error"
};

[_message, _notificationType, _title, 5] call FLO_fnc_notify;
