params [["_fob", objNull, [objNull]]];

if (!hasInterface) exitWith { false };
if (isNull _fob) exitWith {
    hint "Store is unavailable.";
    false
};

FLO_StoreActiveFobNetId = netId _fob;

private _display = findDisplay FLO_StoreDialogIdd;

if (!isNull _display) exitWith {
    [player, FLO_StoreActiveFobNetId] remoteExecCall ["FLO_fnc_storeRequestHydrate", 2];
    true
};

createDialog "FLO_StoreDialog";
_display = findDisplay FLO_StoreDialogIdd;

private _control = _display displayCtrl FLO_StoreBrowserIdc;
uiNamespace setVariable ["FLO_StoreControl", _control];

[_control] call FLO_fnc_storeAddWebEventHandler;
[_control, ["LoadFile", "\z\foof\addons\main\ui\store\index.html"]] call FLO_fnc_storeWebAction;

true
