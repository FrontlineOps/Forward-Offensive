if (!hasInterface) exitWith {};

FLO_ResourceSnapshot = [];

[
    { !isNull player },
    { [player] remoteExecCall ["FLO_fnc_resourceRequestSnapshot", 2] }
] call CBA_fnc_waitUntilAndExecute;

diag_log "[FLO][Resource] Client resource sync initialized";
