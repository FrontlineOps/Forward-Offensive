params ["_unit", "_corpse"];

if (!isServer) exitWith {};
if (isNull _unit) exitWith {};
if (!isPlayer _unit) exitWith {};

private _side = side group _unit;

if !(_side in [west, east]) exitWith {};

private _uid = getPlayerUID _unit;

if (_uid isEqualTo "") exitWith {};

private _sideKey = [_side] call FLO_fnc_resourceSideKey;
private _hasDeathState = _uid in FLO_TicketDeathStates;
private _disconnectRespawn = _uid in FLO_TicketDisconnectedPlayers;

if ((!isNull _corpse) && {_corpse getVariable ["FLO_TicketDisconnecting", false]}) then {
    _disconnectRespawn = true;
};

if (_disconnectRespawn && {!_hasDeathState}) exitWith {
    FLO_TicketDisconnectedPlayers deleteAt _uid;
    _unit setVariable ["FLO_TicketDisconnecting", false];
    _unit setVariable ["FLO_TicketDeathHandled", false];
    _unit setVariable ["FLO_TicketDeathState", ""];
    _unit setVariable ["FLO_TicketDeathSideKey", ""];
    [_unit, ([_side] call FLO_fnc_ticketSideBalance) <= 0, ""] call FLO_fnc_ticketSyncPlayer;

    diag_log format [
        "[FLO][Tickets] Respawn ignored: disconnected uid=%1 side=%2 corpse=%3",
        _uid,
        _sideKey,
        _corpse
    ];
};

FLO_TicketDisconnectedPlayers deleteAt _uid;
_unit setVariable ["FLO_TicketDisconnecting", false];

_unit setVariable ["FLO_TicketDeathHandled", false];
_unit setVariable ["FLO_TicketDeathState", ""];
_unit setVariable ["FLO_TicketDeathSideKey", ""];

private _respawnId = netId _unit;

if (_respawnId isEqualTo "") then {
    _respawnId = str _unit;
};

if (_respawnId in FLO_TicketHandledRespawns) exitWith {};
FLO_TicketHandledRespawns set [_respawnId, true];

if !(_unit getVariable ["FLO_Persistence_Loaded", false]) then {
    private _defaultKitClass = [_sideKey] call FLO_fnc_spawnSideDefaultKitClass;

    if (_defaultKitClass isNotEqualTo "") then {
        [_unit, _defaultKitClass] remoteExecCall ["FLO_fnc_spawnApplyDefaultKit", owner _unit];
    };
};

private _deathState = createHashMap;

if (_uid in FLO_TicketDeathStates) then {
    _deathState = FLO_TicketDeathStates get _uid;
    FLO_TicketDeathStates deleteAt _uid;
};

private _deathResult = "";

if ((count _deathState) > 0) then {
    _deathResult = _deathState get "state";
};

if ((_deathResult isEqualTo "") && {!isNull _corpse}) then {
    _deathResult = _corpse getVariable ["FLO_TicketDeathState", ""];
};

if (_deathResult isNotEqualTo "") exitWith {
    private _locked = ([_side] call FLO_fnc_ticketSideBalance) <= 0;
    private _message = "";

    if ((count _deathState) > 0) then {
        _locked = _deathState get "locked";
        _message = _deathState get "message";
    };

    if (_message isEqualTo "") then {
        private _balance = [_side] call FLO_fnc_ticketSideBalance;
        _message = if (_balance <= 0) then {
            "Respawn ticket consumed. No tickets remain."
        } else {
            format ["Respawn ticket consumed. %1 tickets remain.", _balance]
        };
    };

    [_unit, _locked, _message] call FLO_fnc_ticketSyncPlayer;

    if (_deathResult isEqualTo "denied") then {
        _unit setDamage 1;

        diag_log format [
            "[FLO][Tickets] Denied respawn for uid=%1 side=%2 noTickets",
            _uid,
            [_side] call FLO_fnc_resourceSideKey
        ];
    };
};

if !([_side, FLO_TicketRespawnCost, format ["respawn %1", _uid]] call FLO_fnc_ticketConsume) exitWith {
    private _message = format ["%1 has no respawn tickets.", _sideKey];

    [_unit, true, _message] call FLO_fnc_ticketSyncPlayer;
    _unit setDamage 1;

    diag_log format [
        "[FLO][Tickets] Denied respawn for uid=%1 side=%2 noTickets",
        _uid,
        _sideKey
    ];
};

private _balance = [_side] call FLO_fnc_ticketSideBalance;
private _locked = _balance <= 0;
private _message = if (_locked) then {
    "Respawn ticket consumed. No tickets remain."
} else {
    format ["Respawn ticket consumed. %1 tickets remain.", _balance]
};

[_unit, _locked, _message] call FLO_fnc_ticketSyncPlayer;
