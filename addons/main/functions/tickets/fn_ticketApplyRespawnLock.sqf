params ["_locked", ["_message", ""], ["_respawnDelay", FLO_TicketRespawnDelay], ["_lockDelay", FLO_TicketNoTicketRespawnDelay]];

if (!hasInterface) exitWith {};

if (isMultiplayer && {remoteExecutedOwner isNotEqualTo 2} && {remoteExecutedOwner isNotEqualTo 0}) exitWith {
    diag_log format ["[FLO][Tickets] Rejected respawn lock from owner %1", remoteExecutedOwner];
};

setPlayerRespawnTime ([_respawnDelay, _lockDelay] select _locked);

if (_message isNotEqualTo "") then {
    hint _message;
};
