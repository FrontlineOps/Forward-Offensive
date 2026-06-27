params ["_unit", "_recordData", ["_attempt", 0]];

if (!isServer) exitWith {};
if (isNull _unit) exitWith {};
if (!isPlayer _unit) exitWith {};

private _owner = owner _unit;

if (_owner > 2) exitWith {
    [_recordData] remoteExecCall ["FLO_fnc_persistenceApplyPlayerState", _owner];
};

if (hasInterface && {player isEqualTo _unit}) exitWith {
    [_recordData] call FLO_fnc_persistenceApplyPlayerState;
};

if (_attempt < 20) exitWith {
    [
        {
            params ["_unit", "_recordData", "_attempt"];
            [_unit, _recordData, _attempt + 1] call FLO_fnc_persistenceSyncPlayerState;
        },
        [_unit, _recordData, _attempt],
        0.5
    ] call CBA_fnc_waitAndExecute;
};

diag_log format [
    "[FLO][Persistence] Could not sync saved player state to %1 owner=%2",
    _unit,
    _owner
];
