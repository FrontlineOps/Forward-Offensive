params ["_message"];

if (!hasInterface) exitWith {};
if (isNull player) exitWith {};

private _parent = findDisplay 46;

if (isNull _parent) then {
    _parent = findDisplay 49;
};

if (isNull _parent) exitWith {
    [_message, "warning", "Tickets"] call FLO_fnc_notify;
};

private _existing = uiNamespace getVariable ["FLO_TicketManualRespawnConfirmDisplay", displayNull];

if (!isNull _existing) then {
    _existing closeDisplay 2;
};

private _display = _parent createDisplay "RscDisplayEmpty";
uiNamespace setVariable ["FLO_TicketManualRespawnConfirmDisplay", _display];

_display displayAddEventHandler [
    "Unload",
    {
        uiNamespace setVariable ["FLO_TicketManualRespawnConfirmDisplay", displayNull];
    }
];

_display displayAddEventHandler [
    "KeyDown",
    {
        params ["_display", "_key"];

        if (_key isEqualTo 1) exitWith {
            _display closeDisplay 2;
            true
        };

        false
    }
];

private _x = safeZoneX + (safeZoneW * 0.32);
private _y = safeZoneY + (safeZoneH * 0.34);
private _w = safeZoneW * 0.36;
private _h = safeZoneH * 0.24;
private _pad = 0.014 * safeZoneW;
private _line = 0.036 * safeZoneH;

private _back = _display ctrlCreate ["RscText", -1];
_back ctrlSetPosition [_x, _y, _w, _h];
_back ctrlSetBackgroundColor [0.02, 0.025, 0.03, 0.94];
_back ctrlCommit 0;

private _accent = _display ctrlCreate ["RscText", -1];
_accent ctrlSetPosition [_x, _y, 0.006 * safeZoneW, _h];
_accent ctrlSetBackgroundColor [1, 0.56, 0.12, 1];
_accent ctrlCommit 0;

private _title = _display ctrlCreate ["RscText", -1];
_title ctrlSetPosition [_x + _pad, _y + (0.018 * safeZoneH), _w - (_pad * 2), _line];
_title ctrlSetText "RESPAWN WILL COST A TICKET";
_title ctrlSetTextColor [1, 0.72, 0.29, 1];
_title ctrlSetFontHeight 0.032;
_title ctrlCommit 0;

private _body = _display ctrlCreate ["RscStructuredText", -1];
_body ctrlSetPosition [_x + _pad, _y + (0.068 * safeZoneH), _w - (_pad * 2), 0.08 * safeZoneH];
_body ctrlSetStructuredText parseText format [
    "<t font='RobotoCondensed' size='1.05' color='#F2F7FA'>%1</t>",
    _message
];
_body ctrlCommit 0;

private _hint = _display ctrlCreate ["RscText", -1];
_hint ctrlSetPosition [_x + _pad, _y + (0.145 * safeZoneH), _w - (_pad * 2), _line];
_hint ctrlSetText "Server ticket handling remains authoritative.";
_hint ctrlSetTextColor [0.62, 0.7, 0.77, 1];
_hint ctrlSetFontHeight 0.023;
_hint ctrlCommit 0;

private _cancel = _display ctrlCreate ["RscButtonMenu", -1];
_cancel ctrlSetPosition [_x + _pad, _y + _h - (0.052 * safeZoneH), 0.15 * safeZoneW, 0.038 * safeZoneH];
_cancel ctrlSetText "CANCEL";
_cancel ctrlCommit 0;
_cancel ctrlAddEventHandler [
    "ButtonClick",
    {
        ctrlParent (_this # 0) closeDisplay 2;
    }
];

private _confirm = _display ctrlCreate ["RscButtonMenu", -1];
_confirm ctrlSetPosition [_x + _w - _pad - (0.15 * safeZoneW), _y + _h - (0.052 * safeZoneH), 0.15 * safeZoneW, 0.038 * safeZoneH];
_confirm ctrlSetText "RESPAWN";
_confirm ctrlCommit 0;
_confirm ctrlAddEventHandler [
    "ButtonClick",
    {
        private _display = ctrlParent (_this # 0);
        _display closeDisplay 1;

        private _pauseDisplay = findDisplay 49;

        if (!isNull _pauseDisplay) then {
            _pauseDisplay closeDisplay 2;
        };

        player setDamage 1;
    }
];
