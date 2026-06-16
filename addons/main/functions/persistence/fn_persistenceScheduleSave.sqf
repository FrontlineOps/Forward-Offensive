params [["_reason", "dirty", [""]], ["_delay", FLO_PersistenceEventSaveDelay, [0]]];

if (!isServer) exitWith {};
if (!FLO_PersistenceEnabled) exitWith {};

FLO_PersistenceDirty = true;

if (FLO_PersistenceSaveScheduled) exitWith {};

FLO_PersistenceSaveScheduled = true;

[
    {
        params ["_reason"];

        FLO_PersistenceSaveScheduled = false;

        if (FLO_PersistenceDirty) then {
            [_reason] call FLO_fnc_persistenceSave;
        };
    },
    [_reason],
    _delay
] call CBA_fnc_waitAndExecute;
