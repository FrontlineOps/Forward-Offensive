if ((toLower missionName) in ["intro", "introexp"]) exitWith {};

if (isServer) then {
    [] call FLO_fnc_intelInitServer;
};

if (hasInterface) then {
    [] call FLO_fnc_intelInitClient;
};
