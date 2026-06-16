if ((toLower missionName) in ["intro", "introexp"]) exitWith {};

if (isServer) then {
    [] call FLO_fnc_commandInitServer;
};

if (hasInterface) then {
    [] call FLO_fnc_commandClientInit;
};
