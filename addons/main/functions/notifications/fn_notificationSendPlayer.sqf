params [
    ["_player", objNull, [objNull]],
    ["_payload", createHashMap, [createHashMap]]
];

if (!isServer) exitWith {};
if (isNull _player) exitWith {};

private _owner = owner _player;

if (_owner <= 0) exitWith {
    if (hasInterface && {player isEqualTo _player}) then {
        [_payload] call FLO_fnc_notificationReceive;
    };
};

[_payload] remoteExecCall ["FLO_fnc_notificationReceive", _owner];
