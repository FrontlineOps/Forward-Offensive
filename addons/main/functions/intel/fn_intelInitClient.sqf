if (!hasInterface) exitWith {};

[
    { !isNull player },
    {
        {
            if (_x getVariable ["FLO_Intel_Searchable", false]) then {
                [_x] call FLO_fnc_intelAddClientAction;
            };
        } forEach allDeadMen;

        diag_log "[FLO][Intel] Client intel actions initialized";
    },
    []
] call CBA_fnc_waitUntilAndExecute;
