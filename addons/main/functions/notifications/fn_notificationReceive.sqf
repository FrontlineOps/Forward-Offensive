params ["_payload"];

if (!hasInterface) exitWith {};

if (isMultiplayer && {remoteExecutedOwner isNotEqualTo 2} && {remoteExecutedOwner isNotEqualTo 0}) exitWith {
    diag_log format ["[FLO][Notification] Rejected notification payload from owner %1", remoteExecutedOwner];
};

if ((typeName _payload) isNotEqualTo "HASHMAP") exitWith {};
if !(("mode" in _payload) && {"message" in _payload}) exitWith {};

private _mode = _payload get "mode";
private _message = _payload get "message";
private _type = "info";
private _title = "";
private _duration = FLO_NotificationDefaultDuration;

if ("type" in _payload) then {
    _type = _payload get "type";
};

if ("title" in _payload) then {
    _title = _payload get "title";
};

if ("duration" in _payload) then {
    _duration = _payload get "duration";
};

if (_mode isEqualTo "announce") exitWith {
    [_title, _message, _type, _duration] call FLO_fnc_announce;
};

[_message, _type, _title, _duration] call FLO_fnc_notify;
