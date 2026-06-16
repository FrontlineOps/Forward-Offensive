params ["_player"];

if (!isServer) exitWith {};
if (isNull _player) exitWith {};
if !((side group _player) in [west, east]) exitWith {};

private _snapshot = [_player] call FLO_fnc_commandBuildSideSnapshot;
private _owner = owner _player;

if (_owner <= 2) exitWith {
    if (hasInterface && {_player isEqualTo player}) then {
        [_snapshot] call FLO_fnc_commandReceiveSnapshot;
    };
};

[_snapshot] remoteExecCall ["FLO_fnc_commandReceiveSnapshot", _owner];
