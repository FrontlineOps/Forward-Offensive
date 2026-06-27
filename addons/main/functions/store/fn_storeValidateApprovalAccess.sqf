params ["_player"];

if (!isServer) exitWith {
    createHashMapFromArray [
        ["success", false],
        ["message", "Store approval access must be validated by the server."],
        ["owner", 0]
    ]
};

private _requestOwner = remoteExecutedOwner;

if (isNull _player) exitWith {
    createHashMapFromArray [
        ["success", false],
        ["message", "Invalid player for Store approvals."],
        ["owner", _requestOwner]
    ]
};

private _playerOwner = owner _player;

if (_requestOwner <= 2) then {
    _requestOwner = _playerOwner;
};

if ((_requestOwner > 2) && {_playerOwner isNotEqualTo _requestOwner}) exitWith {
    diag_log format [
        "[FLO][Store] Rejected spoofed approval request player=%1 requestOwner=%2 actualOwner=%3",
        name _player,
        _requestOwner,
        _playerOwner
    ];

    createHashMapFromArray [
        ["success", false],
        ["message", "Store approval request rejected."],
        ["owner", _requestOwner]
    ]
};

if (!alive _player) exitWith {
    createHashMapFromArray [
        ["success", false],
        ["message", "You must be alive to review Store approvals."],
        ["owner", _requestOwner]
    ]
};

private _side = side group _player;

if !(_side in [west, east]) exitWith {
    createHashMapFromArray [
        ["success", false],
        ["message", "Store approvals are only available to BLUFOR and OPFOR."],
        ["owner", _requestOwner]
    ]
};

if !([_player] call FLO_fnc_commandPlayerIsCommanderOrDeputy) exitWith {
    createHashMapFromArray [
        ["success", false],
        ["message", "Only the commander or deputy can review Store approvals."],
        ["owner", _requestOwner]
    ]
};

private _sideKey = [_side] call FLO_fnc_resourceSideKey;
private _faction = [_sideKey] call FLO_fnc_storeSelectedFaction;

createHashMapFromArray [
    ["success", true],
    ["message", ""],
    ["owner", _requestOwner],
    ["player", _player],
    ["side", _side],
    ["sideKey", _sideKey],
    ["sideName", ["BLUFOR", "OPFOR"] select (_side isEqualTo east)],
    ["factionClass", _faction get "class"],
    ["factionName", _faction get "name"]
]
