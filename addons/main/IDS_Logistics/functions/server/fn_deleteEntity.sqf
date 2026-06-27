params [
    ["_netId", "", [""]],
    ["_player", objNull, [objNull]]
];

if (!isServer) exitWith {};

private _owner = owner _player;
if ((remoteExecutedOwner > 2) && {_owner isNotEqualTo remoteExecutedOwner}) exitWith {
    diag_log format [
        "[FOOF][IDS] Rejecting logistics delete owner mismatch requestOwner=%1 playerOwner=%2",
        remoteExecutedOwner,
        _owner
    ];
};

if (isNull _player || {!alive _player}) exitWith {};

private _side = side group _player;
if !(_side in [west, east]) exitWith {
    [false, "Only BLUFOR and OPFOR can delete logistics objects."] remoteExecCall ["IDS_Logistics_fnc_receivePlacementResult", _owner];
};

if (!([_player, "logistics"] call FLO_fnc_commandPlayerHasAuthority)) exitWith {
    [false, "Only the commander or deputy can use base logistics."] remoteExecCall ["IDS_Logistics_fnc_receivePlacementResult", _owner];
};

private _sideKey = [_side] call FLO_fnc_resourceSideKey;
private _entity = objectFromNetId _netId;
if (isNull _entity) exitWith {
    [false, "The selected logistics object no longer exists."] remoteExecCall ["IDS_Logistics_fnc_receivePlacementResult", _owner];
};

if !(_entity getVariable ["IDS_Logistics_isPlacedEntity", false]) exitWith {
    [false, "That object is not managed by IDS Logistics."] remoteExecCall ["IDS_Logistics_fnc_receivePlacementResult", _owner];
};

if ((_entity getVariable ["IDS_Logistics_SideKey", ""]) isNotEqualTo _sideKey) exitWith {
    [false, "You cannot delete the other faction's logistics objects."] remoteExecCall ["IDS_Logistics_fnc_receivePlacementResult", _owner];
};

if (!([_side, getPosASL _player] call FLO_fnc_fobCanBuildAt)) exitWith {
    [false, "You must be inside a friendly FOB build radius to delete logistics objects."] remoteExecCall ["IDS_Logistics_fnc_receivePlacementResult", _owner];
};

if (!([_side, getPosASL _entity] call FLO_fnc_fobCanBuildAt)) exitWith {
    [false, "Logistics objects can only be deleted inside a friendly FOB build radius."] remoteExecCall ["IDS_Logistics_fnc_receivePlacementResult", _owner];
};

if ((_player distance2D _entity) > 90) exitWith {
    [false, "The selected logistics object is too far away to delete."] remoteExecCall ["IDS_Logistics_fnc_receivePlacementResult", _owner];
};

private _blockingPlayerIndex = allPlayers findIf {
    (_x isNotEqualTo _player) && {alive _x} && {_x distance2D _entity < 5}
};

if (_blockingPlayerIndex isNotEqualTo -1) exitWith {
    [false, "Cannot delete while another player is close to the object."] remoteExecCall ["IDS_Logistics_fnc_receivePlacementResult", _owner];
};

private _type = typeOf _entity;
private _index = IDS_Logistics_PlacedEntities find _entity;
if (_index isNotEqualTo -1) then {
    IDS_Logistics_PlacedEntities deleteAt _index;
};
deleteVehicle _entity;
["idsDelete"] call FLO_fnc_persistenceScheduleSave;

[true, format ["Deleted %1.", _type]] remoteExecCall ["IDS_Logistics_fnc_receivePlacementResult", _owner];
