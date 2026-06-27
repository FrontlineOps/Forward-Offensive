if (isServer) then {
    [] call FLO_fnc_storeInitServer;
};

if (hasInterface) then {
    [] call FLO_fnc_storeApprovalsClientInit;
};
