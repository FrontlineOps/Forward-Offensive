params [
    "_access",
    "_cart",
    "_total",
    "_deploymentFundSpent",
    "_personalSpent",
    "_factionTotal",
    "_gearCount",
    "_vehicleCount"
];

if (!isServer) exitWith { createHashMap };

private _sideKey = _access get "sideKey";
private _player = _access get "player";
private _playerUid = getPlayerUID _player;
private _fob = _access get "fob";
private _cartRecords = [];

{
    _cartRecords pushBack [
        ["className", _x get "className"],
        ["entryKind", _x get "entryKind"],
        ["quantity", _x get "quantity"],
        ["container", _x get "container"],
        ["slot", _x get "slot"]
    ];
} forEach _cart;

FLO_StorePendingApprovalCounter = FLO_StorePendingApprovalCounter + 1;

private _approvalId = format [
    "%1_APPROVAL_%2_%3",
    _sideKey,
    floor (diag_tickTime * 1000),
    FLO_StorePendingApprovalCounter
];

private _record = createHashMapFromArray [
    ["id", _approvalId],
    ["side", _access get "side"],
    ["sideKey", _sideKey],
    ["owner", _access get "owner"],
    ["playerUid", _playerUid],
    ["playerName", name _player],
    ["fobNetId", _access get "fobNetId"],
    ["fobId", _fob getVariable ["FLO_FOB_Id", ""]],
    ["cart", _cartRecords],
    ["total", _total],
    ["deploymentFundSpent", _deploymentFundSpent],
    ["personalSpent", _personalSpent],
    ["factionTotal", _factionTotal],
    ["gearCount", _gearCount],
    ["vehicleCount", _vehicleCount],
    ["createdAt", diag_tickTime]
];

FLO_StorePendingApprovals pushBack _record;

diag_log format [
    "[FLO][Store] Queued approval side=%1 player=%2 total=%3 personal=%4 faction=%5 gear=%6 vehicles=%7 id=%8",
    _sideKey,
    name _player,
    _total,
    _personalSpent,
    _factionTotal,
    _gearCount,
    _vehicleCount,
    _approvalId
];

["storeApprovalQueued"] call FLO_fnc_persistenceScheduleSave;

createHashMapFromArray [
    ["id", _approvalId],
    ["playerName", name _player],
    ["total", _total],
    ["deploymentFundSpent", _deploymentFundSpent],
    ["personalSpent", _personalSpent],
    ["factionTotal", _factionTotal],
    ["gearCount", _gearCount],
    ["vehicleCount", _vehicleCount],
    ["createdAt", diag_tickTime]
]
