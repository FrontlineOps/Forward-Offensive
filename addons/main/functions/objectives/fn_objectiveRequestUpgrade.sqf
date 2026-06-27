params [
    ["_player", objNull, [objNull]],
    ["_objectiveId", "", [""]]
];

if (!isServer) exitWith {};
if (isNull _player) exitWith {};

private _owner = owner _player;
private _requestOwner = remoteExecutedOwner;

if (_requestOwner <= 2) then {
    _requestOwner = _owner;
};

private _notify = {
    params ["_message", ["_type", "info"]];

    [_player, createHashMapFromArray [
        ["mode", "notify"],
        ["type", _type],
        ["title", "AO Upgrade"],
        ["message", _message],
        ["duration", 5]
    ]] call FLO_fnc_notificationSendPlayer;
};

if ((_requestOwner > 2) && {_owner isNotEqualTo _requestOwner}) exitWith {
    diag_log format [
        "[FLO][Objective] Rejected spoofed AO upgrade player=%1 requestOwner=%2 actualOwner=%3 objective=%4",
        name _player,
        _requestOwner,
        _owner,
        _objectiveId
    ];
};

if (!alive _player) exitWith {
    ["You must be alive to upgrade an AO.", "warning"] call _notify;
};

private _side = side group _player;

if !(_side in [west, east]) exitWith {
    ["AO upgrades are only available to BLUFOR and OPFOR.", "warning"] call _notify;
};

if !(_objectiveId in FLO_Objectives) exitWith {
    ["AO is no longer available.", "error"] call _notify;
};

private _objective = FLO_Objectives get _objectiveId;
private _sideKey = [_side] call FLO_fnc_resourceSideKey;

if ((_objective get "owner") isNotEqualTo _side) exitWith {
    ["Your side must control this AO before upgrading it.", "warning"] call _notify;
};

if ((_objective get "state") isNotEqualTo "held") exitWith {
    ["AO must be held before it can be upgraded.", "warning"] call _notify;
};

if !([_player, "build"] call FLO_fnc_commandPlayerHasAuthority) exitWith {
    ["Only command-authorized players can upgrade AOs.", "warning"] call _notify;
};

private _level = floor (_objective get "level");
private _pendingLevel = floor (_objective get "pendingUpgradeLevel");

if (_level >= FLO_ObjectiveMaxLevel) exitWith {
    ["AO is already fully upgraded.", "info"] call _notify;
};

if (_pendingLevel > 0) exitWith {
    ["AO upgrade is already in progress.", "info"] call _notify;
};

private _inPerson = (_player distance2D (_objective get "position")) <= ((_objective get "displayRadius") + FLO_ObjectiveInPersonUpgradeExtraRadius);
private _cost = [_objective, _inPerson] call FLO_fnc_objectiveUpgradeCost;

if !([_side, _cost, format ["AO upgrade %1 to level %2", _objectiveId, _level + 1]] call FLO_fnc_resourceSpend) exitWith {
    [format ["Not enough faction balance. Required: $%1.", _cost], "warning"] call _notify;
};

private _newLevel = _level + 1;
private _duration = [_level] call FLO_fnc_objectiveUpgradeDuration;
private _startedAt = diag_tickTime;

_objective set ["pendingUpgradeLevel", _newLevel];
_objective set ["pendingUpgradeStartedAt", _startedAt];
_objective set ["pendingUpgradeCompleteAt", _startedAt + _duration];

diag_log format [
    "[FLO][Objective] %1 started AO upgrade %2 to level %3 cost=%4 balance=%5 duration=%6 mode=%7",
    _sideKey,
    _objectiveId,
    _newLevel,
    _cost,
    FLO_ResourceBalances get _sideKey,
    _duration,
    ["remote", "in-person"] select _inPerson
];

[false, [], [_objectiveId]] call FLO_fnc_objectivePublishSnapshot;
["objectiveUpgrade"] call FLO_fnc_persistenceScheduleSave;

[
    format [
        "%1 upgrade to Level %2 - %3 started.",
        _objective get "name",
        _newLevel,
        [_newLevel] call FLO_fnc_objectiveLevelName
    ],
    "success"
] call _notify;
