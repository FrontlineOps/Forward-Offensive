params [["_payload", createHashMap, [createHashMap]]];

if (!isServer) exitWith {};

[_payload] remoteExecCall ["FLO_fnc_notificationReceive", 0];
