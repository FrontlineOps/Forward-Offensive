params ["_unit"];

if (!isServer) exitWith {};
if (isNull _unit) exitWith {};

private _owner = owner _unit;

if ((remoteExecutedOwner > 2) && {_owner isNotEqualTo remoteExecutedOwner}) exitWith {
    diag_log format [
        "[FLO][Resource] Rejected resource snapshot request from owner %1 for owner %2",
        remoteExecutedOwner,
        _owner
    ];
};

[_owner] call FLO_fnc_resourceSendSnapshot;
