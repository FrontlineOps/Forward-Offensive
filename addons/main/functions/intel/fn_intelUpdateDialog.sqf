if (!hasInterface) exitWith {};

private _control = uiNamespace getVariable ["FLO_IntelControl", controlNull];

if (isNull _control) exitWith {};
if (!FLO_IntelBrowserReady) exitWith {};

private _payload = if ((count _this) > 0) then {
    _this select 0
} else {
    [] call FLO_fnc_intelBuildInitialPayload
};

private _script = format [
    "if (window.FOOFIntel) { window.FOOFIntel.receive(%1); }",
    toJSON _payload
];

[_control, ["ExecJS", _script]] call FLO_fnc_intelWebAction;
