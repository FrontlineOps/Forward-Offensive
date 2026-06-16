params [["_delay", FLO_ResourceSnapshotBroadcastDelay, [0]]];

if (!isServer) exitWith {};
if (FLO_ResourceSnapshotScheduled) exitWith {};

FLO_ResourceSnapshotScheduled = true;

[
    {
        FLO_ResourceSnapshotScheduled = false;
        [0] call FLO_fnc_resourceSendSnapshot;
    },
    [],
    _delay
] call CBA_fnc_waitAndExecute;
