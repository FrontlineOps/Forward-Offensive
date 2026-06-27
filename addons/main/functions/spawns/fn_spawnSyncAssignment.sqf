params ["_player", "_payload", ["_attempt", 0]];

if (!isServer) exitWith {};
if (isNull _player) exitWith {};
if (!isPlayer _player) exitWith {};

private _owner = owner _player;

if (_owner > 2) exitWith {
    _payload remoteExecCall ["FLO_fnc_spawnApplyAssignment", _owner];
};

if (hasInterface && {player isEqualTo _player}) exitWith {
    _payload call FLO_fnc_spawnApplyAssignment;
};

if (_attempt < 20) exitWith {
    [
        {
            params ["_player", "_payload", "_attempt"];
            [_player, _payload, _attempt + 1] call FLO_fnc_spawnSyncAssignment;
        },
        [_player, _payload, _attempt],
        0.5
    ] call CBA_fnc_waitAndExecute;
};

diag_log format [
    "[FLO][Spawn] Could not sync deployment assignment to %1 owner=%2 payload=%3",
    _player,
    _owner,
    _payload
];
