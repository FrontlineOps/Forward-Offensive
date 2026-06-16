params ["_owner", "_payload"];

if (!isServer) exitWith {};

if (_owner <= 0) exitWith {
    if (hasInterface) then {
        [_payload] call FLO_fnc_intelReceiveResult;
    };
};

[_payload] remoteExecCall ["FLO_fnc_intelReceiveResult", _owner];
