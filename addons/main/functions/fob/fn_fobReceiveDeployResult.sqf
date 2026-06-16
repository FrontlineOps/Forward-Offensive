params ["_success", "_message"];

if (!hasInterface) exitWith {};

[_message, ["error", "success"] select _success, "Deployment"] call FLO_fnc_notify;

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
