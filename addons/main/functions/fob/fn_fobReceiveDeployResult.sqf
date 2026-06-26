params ["_success", "_message", ["_title", "Deployment", [""]]];

if (!hasInterface) exitWith {};
if (isMultiplayer && {remoteExecutedOwner isNotEqualTo 2} && {remoteExecutedOwner isNotEqualTo 0}) exitWith {
    diag_log format ["[FLO][FOB] Rejected deployment result from owner %1", remoteExecutedOwner];
};

[_message, ["error", "success"] select _success, _title] call FLO_fnc_notify;

private _control = uiNamespace getVariable ["FLO_DeployControl", controlNull];

if (!isNull _control) then {
    private _payload = createHashMapFromArray [
        ["success", _success],
        ["message", _message]
    ];
    private _script = format [
        "if (window.FOOFDeploy) { window.FOOFDeploy.receiveResult(%1); }",
        toJSON _payload
    ];

    [_control, ["ExecJS", _script]] call FLO_fnc_fobDeployWebAction;

    FLO_FOBDeployRenderKey = "";
    [] call FLO_fnc_fobUpdateDeployDialog;
};
