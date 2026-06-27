if (!hasInterface) exitWith { false };

private _display = findDisplay FLO_StoreApprovalsDialogIdd;

if (!isNull _display) exitWith {
    [player] remoteExecCall ["FLO_fnc_storeRequestApprovalSnapshot", 2];
    true
};

createDialog "FLO_StoreApprovalsDialog";
_display = findDisplay FLO_StoreApprovalsDialogIdd;

private _control = _display displayCtrl FLO_StoreApprovalsBrowserIdc;
uiNamespace setVariable ["FLO_StoreApprovalsControl", _control];

[_control] call FLO_fnc_storeAddApprovalsWebEventHandler;
[_control, ["LoadFile", "\z\foof\addons\main\ui\store\approvals.html"]] call FLO_fnc_storeWebAction;

true
