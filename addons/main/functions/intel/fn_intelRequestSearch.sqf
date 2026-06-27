params ["_player", "_bodyNetId"];

if (!isServer) exitWith {};
if (isNull _player) exitWith {};

private _owner = owner _player;

if ((remoteExecutedOwner > 2) && {_owner isNotEqualTo remoteExecutedOwner}) exitWith {
    diag_log format [
        "[FLO][Intel] Rejected intel search request from owner %1 for owner %2",
        remoteExecutedOwner,
        _owner
    ];
};

if (!alive _player) exitWith {
    [_owner, createHashMapFromArray [
        ["success", false],
        ["type", "error"],
        ["title", "Intel"],
        ["message", "Cannot search intel while dead."]
    ]] call FLO_fnc_intelSendResult;
};

private _playerSide = side group _player;

if !(_playerSide in [west, east]) exitWith {
    [_owner, createHashMapFromArray [
        ["success", false],
        ["type", "error"],
        ["title", "Intel"],
        ["message", "Intel search is only available to BLUFOR and OPFOR."]
    ]] call FLO_fnc_intelSendResult;
};

private _body = objectFromNetId _bodyNetId;

if (isNull _body) exitWith {
    [_owner, createHashMapFromArray [
        ["success", false],
        ["type", "error"],
        ["title", "Intel"],
        ["message", "Intel source is unavailable."]
    ]] call FLO_fnc_intelSendResult;
};

if (alive _body) exitWith {
    [_owner, createHashMapFromArray [
        ["success", false],
        ["type", "error"],
        ["title", "Intel"],
        ["message", "Intel source is not a casualty."]
    ]] call FLO_fnc_intelSendResult;
};

if ((_player distance2D _body) > (FLO_IntelSearchDistance + 2)) exitWith {
    [_owner, createHashMapFromArray [
        ["success", false],
        ["type", "error"],
        ["title", "Intel"],
        ["message", "Move closer to search the body."]
    ]] call FLO_fnc_intelSendResult;
};

if !(_bodyNetId in FLO_IntelBodies) exitWith {
    [_owner, createHashMapFromArray [
        ["success", false],
        ["type", "error"],
        ["title", "Intel"],
        ["message", "This casualty has no recoverable intel."]
    ]] call FLO_fnc_intelSendResult;
};

private _record = FLO_IntelBodies get _bodyNetId;
private _playerSideKey = [_playerSide] call FLO_fnc_resourceSideKey;
private _bodySideKey = _record get "sideKey";

if (_bodySideKey isEqualTo _playerSideKey) exitWith {
    [_owner, createHashMapFromArray [
        ["success", false],
        ["type", "error"],
        ["title", "Intel"],
        ["message", "Friendly casualties cannot provide enemy intel."]
    ]] call FLO_fnc_intelSendResult;
};

if (_record get "searched") exitWith {
    [_owner, createHashMapFromArray [
        ["success", false],
        ["type", "error"],
        ["title", "Intel"],
        ["message", "This body has already been searched."]
    ]] call FLO_fnc_intelSendResult;
};

_record set ["searched", true];
_record set ["searchedBy", getPlayerUID _player];
_record set ["searchedAt", serverTime];
_body setVariable ["FLO_Intel_Searchable", false, true];

if !(_record get "hasIntel") exitWith {
    [_owner, createHashMapFromArray [
        ["success", true],
        ["type", "none"],
        ["title", "No Intel Found"],
        ["message", "The casualty carried no usable intel."]
    ]] call FLO_fnc_intelSendResult;
};

private _payload = createHashMap;

if ((random 1) < FLO_IntelBaseChance) then {
    _payload = [_playerSideKey, _bodySideKey] call FLO_fnc_intelFindBaseTarget;
};

if (((count _payload) isEqualTo 0) && {(random 1) < FLO_IntelCommandRoleChance}) then {
    _payload = [_bodySideKey] call FLO_fnc_intelFindCommandRoleTarget;
};

if ((count _payload) isEqualTo 0) then {
    _payload = [_player, _body, _bodySideKey] call FLO_fnc_intelFindPlayerTarget;
};

if ((count _payload) isEqualTo 0) then {
    _payload = createHashMapFromArray [
        ["success", true],
        ["type", "none"],
        ["title", "Stale Intel"],
        ["message", "The recovered intel was too stale to plot."]
    ];
};

[_owner, _payload] call FLO_fnc_intelSendResult;
