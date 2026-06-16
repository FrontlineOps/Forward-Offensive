if (!isServer) exitWith {};

FLO_PersistenceLoopHandle = [
    {
        ["periodic"] call FLO_fnc_persistenceSave;
    },
    FLO_PersistenceSaveInterval,
    []
] call CBA_fnc_addPerFrameHandler;
