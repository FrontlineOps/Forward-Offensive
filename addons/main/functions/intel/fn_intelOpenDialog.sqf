params [["_body", objNull, [objNull]]];

if (!hasInterface) exitWith { false };

if (isNull _body) exitWith {
    ["Intel source is unavailable.", "error", "Intel"] call FLO_fnc_notify;
    false
};

if (!alive player) exitWith {
    ["Cannot search intel while dead.", "warning", "Intel"] call FLO_fnc_notify;
    false
};

if (alive _body) exitWith {
    ["Intel can only be searched from enemy casualties.", "warning", "Intel"] call FLO_fnc_notify;
    false
};

if ((player distance2D _body) > (FLO_IntelSearchDistance + 1)) exitWith {
    ["Move closer to search the body.", "warning", "Intel"] call FLO_fnc_notify;
    false
};

private _playerSide = side group player;

if !(_playerSide in [west, east]) exitWith {
    ["Intel search is only available to BLUFOR and OPFOR.", "warning", "Intel"] call FLO_fnc_notify;
    false
};

private _bodySideKey = _body getVariable ["FLO_Intel_BodySideKey", ""];
private _playerSideKey = [_playerSide] call FLO_fnc_resourceSideKey;

if (_bodySideKey isEqualTo _playerSideKey) exitWith {
    ["Friendly casualties cannot provide enemy intel.", "warning", "Intel"] call FLO_fnc_notify;
    false
};

if !(_body getVariable ["FLO_Intel_Searchable", false]) exitWith {
    ["This body has already been searched.", "warning", "Intel"] call FLO_fnc_notify;
    false
};

FLO_IntelActiveBodyNetId = netId _body;

private _display = findDisplay FLO_IntelDialogIdd;

if (!isNull _display) exitWith {
    [] call FLO_fnc_intelUpdateDialog;
    true
};

createDialog "FLO_IntelDialog";
_display = findDisplay FLO_IntelDialogIdd;

if (isNull _display) exitWith { false };

FLO_IntelBrowserReady = false;

private _control = _display displayCtrl FLO_IntelBrowserIdc;
uiNamespace setVariable ["FLO_IntelControl", _control];

[_control] call FLO_fnc_intelAddWebEventHandler;
[_control, ["LoadFile", "\z\foof\addons\main\ui\intel\index.html"]] call FLO_fnc_intelWebAction;

true
