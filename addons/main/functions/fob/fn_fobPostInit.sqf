if (isServer) then {
    [] call FLO_fnc_fobInitServer;
};

if (hasInterface) then {
    [] call FLO_fnc_fobInitClient;
};
