if ((toLower missionName) in ["intro", "introexp"]) exitWith {};

if (isServer) then {
    [] call FLO_fnc_ticketInitServer;
};

if (hasInterface && {isClass (configFile >> "CfgPatches" >> "ace_medical")}) then {
    FLO_TicketAceMedicalDeathEh = [
        "ace_medical_death",
        {
            params ["_unit"];

            if (_unit isNotEqualTo player) exitWith {};

            private _uid = getPlayerUID player;
            private _sideKey = player getVariable ["FLO_TicketSideKey", ""];

            if (_sideKey isEqualTo "") then {
                private _side = side group player;

                if (_side in [west, east]) then {
                    _sideKey = [_side] call FLO_fnc_resourceSideKey;
                };
            };

            [player, _uid, _sideKey] remoteExecCall ["FLO_fnc_ticketHandleAceMedicalDeath", 2];
        }
    ] call CBA_fnc_addEventHandler;
};

if (hasInterface) then {
    FLO_TicketClientRespawnEh = addMissionEventHandler [
        "EntityRespawned",
        {
            params ["_newEntity", "_oldEntity"];

            if (_newEntity isNotEqualTo player) exitWith {};

            [_newEntity, _oldEntity] remoteExecCall ["FLO_fnc_ticketHandleRespawn", 2];
        }
    ];
};
