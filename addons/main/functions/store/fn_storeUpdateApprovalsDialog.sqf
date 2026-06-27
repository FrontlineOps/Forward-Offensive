params ["_event", "_payload"];

if (!hasInterface) exitWith {};

private _control = uiNamespace getVariable ["FLO_StoreApprovalsControl", controlNull];

if (isNull _control) exitWith {};

private _script = format [
    "if (window.FOOFApprovals) { window.FOOFApprovals.receive(%1, %2); }",
    toJSON _event,
    toJSON _payload
];

[_control, ["ExecJS", _script]] call FLO_fnc_storeWebAction;
