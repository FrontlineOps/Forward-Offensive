if (!hasInterface) exitWith { false };

private _display = findDisplay FLO_ObjectiveAreaDialogIdd;

if (!isNull _display) exitWith {
    _display closeDisplay 0;
    true
};

private _objectiveId = [] call FLO_fnc_objectiveNearestAreaId;

if (_objectiveId isEqualTo "") exitWith {
    ["Move inside an AO to open its objective panel.", "warning", "AO"] call FLO_fnc_notify;
    true
};

[_objectiveId] call FLO_fnc_objectiveOpenAreaDialog
