params ["_snapshot"];

if (!hasInterface) exitWith {};

if (!isServer && {remoteExecutedOwner isNotEqualTo 2}) exitWith {
    diag_log format ["[FLO][Resource] Rejected resource snapshot from owner %1", remoteExecutedOwner];
};

FLO_ResourceSnapshot = _snapshot;
