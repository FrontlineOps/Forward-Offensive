params ["_snapshot", "_fullRefresh"];

if (!hasInterface) exitWith {};

if (!isServer && {remoteExecutedOwner isNotEqualTo 2}) exitWith {
    diag_log format ["[FLO][Objective] Rejected grid snapshot from owner %1", remoteExecutedOwner];
};

[_snapshot, _fullRefresh] call FLO_fnc_objectiveApplyGridSnapshot;
