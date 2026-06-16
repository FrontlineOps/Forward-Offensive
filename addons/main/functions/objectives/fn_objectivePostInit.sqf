if ((toLower missionName) in ["intro", "introexp"]) exitWith {
    diag_log format ["[FLO][Core] Skipping gameplay startup in engine intro mission %1", missionName];
};

if (isServer) then {
    [] call FLO_fnc_objectiveInitServer;
};

if (hasInterface) then {
    [] call FLO_fnc_objectiveClientInit;
    [] call FLO_fnc_resourceClientInit;
    [] call FLO_fnc_spawnClientInit;
};
