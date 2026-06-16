params [["_objectiveId", "", [""]]];

if (!hasInterface) exitWith { false };
if (_objectiveId isEqualTo "") exitWith { false };

FLO_ObjectiveAreaActiveId = _objectiveId;

private _display = findDisplay FLO_ObjectiveAreaDialogIdd;

if (!isNull _display) exitWith {
    [] call FLO_fnc_objectiveUpdateAreaDialog;
    true
};

createDialog "FLO_ObjectiveAreaDialog";
_display = findDisplay FLO_ObjectiveAreaDialogIdd;

if (isNull _display) exitWith { false };

FLO_ObjectiveAreaBrowserReady = false;

private _control = _display displayCtrl FLO_ObjectiveAreaBrowserIdc;
uiNamespace setVariable ["FLO_ObjectiveAreaControl", _control];

[_control] call FLO_fnc_objectiveAddAreaWebEventHandler;
[_control, ["LoadFile", "\z\foof\addons\main\ui\objective\index.html"]] call FLO_fnc_objectiveAreaWebAction;

true
