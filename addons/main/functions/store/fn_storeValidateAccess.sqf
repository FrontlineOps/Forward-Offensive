params ["_player", "_fobNetId"];

if (!isServer) exitWith {
    createHashMapFromArray [
        ["success", false],
        ["message", "Store access must be validated by the server."],
        ["owner", 0]
    ]
};

private _requestOwner = remoteExecutedOwner;

if (isNull _player) exitWith {
    createHashMapFromArray [
        ["success", false],
        ["message", "Invalid player for store request."],
        ["owner", _requestOwner]
    ]
};

private _playerOwner = owner _player;
if (_requestOwner <= 2) then {
    _requestOwner = _playerOwner;
};

if ((_requestOwner > 2) && {_playerOwner isNotEqualTo _requestOwner}) exitWith {
    diag_log format [
        "[FLO][Store] Rejected spoofed store request player=%1 requestOwner=%2 actualOwner=%3",
        name _player,
        _requestOwner,
        _playerOwner
    ];

    createHashMapFromArray [
        ["success", false],
        ["message", "Store request rejected."],
        ["owner", _requestOwner]
    ]
};

if (!alive _player) exitWith {
    createHashMapFromArray [
        ["success", false],
        ["message", "You must be alive to use the store."],
        ["owner", _requestOwner]
    ]
};

private _side = side group _player;

if !(_side in [west, east]) exitWith {
    createHashMapFromArray [
        ["success", false],
        ["message", "The store is only available to BLUFOR and OPFOR."],
        ["owner", _requestOwner]
    ]
};

private _sideKey = [_side] call FLO_fnc_resourceSideKey;

private _fob = objectFromNetId _fobNetId;

if (isNull _fob) exitWith {
    createHashMapFromArray [
        ["success", false],
        ["message", "Store must be opened from a valid base."],
        ["owner", _requestOwner]
    ]
};

if (!alive _fob) exitWith {
    createHashMapFromArray [
        ["success", false],
        ["message", "This base is destroyed."],
        ["owner", _requestOwner]
    ]
};

private _fobId = _fob getVariable ["FLO_FOB_Id", ""];

if (_fobId isEqualTo "") exitWith {
    createHashMapFromArray [
        ["success", false],
        ["message", "Store must be opened from a registered base."],
        ["owner", _requestOwner]
    ]
};

if !(_fobId in FLO_FOBs) exitWith {
    createHashMapFromArray [
        ["success", false],
        ["message", "Store must be opened from an active base."],
        ["owner", _requestOwner]
    ]
};

private _fobRecord = FLO_FOBs get _fobId;
private _registeredFob = _fobRecord get "object";

if (_registeredFob isNotEqualTo _fob) exitWith {
    createHashMapFromArray [
        ["success", false],
        ["message", "Store base registration mismatch."],
        ["owner", _requestOwner]
    ]
};

if !(_fobRecord get "storeEnabled") exitWith {
    createHashMapFromArray [
        ["success", false],
        ["message", "Store is not available at this base."],
        ["owner", _requestOwner]
    ]
};

private _fobSideKey = _fobRecord get "sideKey";

if (_fobSideKey isNotEqualTo _sideKey) exitWith {
    createHashMapFromArray [
        ["success", false],
        ["message", "This base belongs to the other side."],
        ["owner", _requestOwner]
    ]
};

private _buildRadius = _fobRecord get "buildRadius";

if ((_player distance2D _fob) > _buildRadius) exitWith {
    createHashMapFromArray [
        ["success", false],
        ["message", "Move closer to the base to use the store."],
        ["owner", _requestOwner]
    ]
};

private _faction = [_sideKey] call FLO_fnc_storeSelectedFaction;

if !(_faction get "selected") exitWith {
    createHashMapFromArray [
        ["success", false],
        ["message", "Your side has not selected a faction yet."],
        ["owner", _requestOwner]
    ]
};

createHashMapFromArray [
    ["success", true],
    ["message", ""],
    ["owner", _requestOwner],
    ["player", _player],
    ["side", _side],
    ["sideKey", _sideKey],
    ["fob", _fob],
    ["fobRecord", _fobRecord],
    ["fobNetId", _fobNetId],
    ["factionClass", _faction get "class"],
    ["factionName", _faction get "name"]
]
