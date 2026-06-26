params ["_access", "_cart"];

if (!isServer) exitWith {
    createHashMapFromArray [
        ["success", false],
        ["message", "Checkout must run on the server."]
    ]
};

if ((typeName _cart) isNotEqualTo "ARRAY") exitWith {
    createHashMapFromArray [
        ["success", false],
        ["message", "Invalid checkout cart."]
    ]
};

if ((count _cart) <= 0) exitWith {
    createHashMapFromArray [
        ["success", false],
        ["message", "Cart is empty."]
    ]
};

if ((count _cart) > 60) exitWith {
    createHashMapFromArray [
        ["success", false],
        ["message", "Cart has too many lines."]
    ]
};

private _side = _access get "side";
private _sideKey = _access get "sideKey";
private _fob = _access get "fob";
private _fobRecord = _access get "fobRecord";
private _playerUid = getPlayerUID (_access get "player");
private _deploymentFundRemaining = [_playerUid] call FLO_fnc_storeDeploymentFundBalance;
private _catalog = [
    _sideKey,
    _access get "factionClass",
    _access get "factionName"
] call FLO_fnc_storeBuildCatalog;
private _itemsByCategory = _catalog get "itemsByCategory";
private _itemIndex = createHashMap;

{
    private _category = _x select 0;

    {
        private _key = format ["%1:%2", _x get "entryKind", toLower (_x get "className")];
        _itemIndex set [_key, _x];
    } forEach (_itemsByCategory get _category);
} forEach FLO_StoreCategories;

private _ok = true;
private _message = "";
private _total = 0;
private _deploymentEligibleTotal = 0;
private _gearEntries = [];
private _vehicleJobs = [];

for "_i" from 0 to ((count _cart) - 1) do {
    if (_ok) then {
        private _entry = _cart select _i;

        if ((typeName _entry) isNotEqualTo "HASHMAP") then {
            _ok = false;
            _message = "Invalid cart line.";
        } else {
            if (!(("className" in _entry) && {"entryKind" in _entry})) then {
                _ok = false;
                _message = "Cart line is missing item data.";
            } else {
                private _className = _entry get "className";
                private _entryKind = _entry get "entryKind";
                private _quantity = 1;
                private _container = "auto";
                private _slot = "";

                if ("quantity" in _entry) then {
                    _quantity = _entry get "quantity";
                };

                if ("container" in _entry) then {
                    _container = _entry get "container";
                };

                if ("slot" in _entry) then {
                    _slot = _entry get "slot";
                };

                if (((typeName _className) isNotEqualTo "STRING") || {((typeName _entryKind) isNotEqualTo "STRING") || {((typeName _quantity) isNotEqualTo "SCALAR") || {((typeName _container) isNotEqualTo "STRING") || {((typeName _slot) isNotEqualTo "STRING")}}}}) then {
                    _ok = false;
                    _message = "Cart line has invalid item data.";
                } else {
                    _quantity = floor _quantity;

                    if ((_quantity < 1) || {_quantity > 50}) then {
                        _ok = false;
                        _message = "Cart quantity is invalid.";
                    } else {
                        if ((_entryKind isEqualTo "vehicle") && {_quantity > 3}) then {
                            _ok = false;
                            _message = "Vehicle quantity is too high.";
                        } else {
                            if !(_container in FLO_StoreGearContainers) then {
                                    _ok = false;
                                    _message = "Cart line has invalid container target.";
                                } else {
                                    if !(_slot in ["", "primary", "handgun", "secondary", "assigned", "uniform", "vest", "backpack", "headgear", "facewear", "binocular"]) then {
                                        _ok = false;
                                        _message = "Cart line has invalid gear slot.";
                                    } else {
                                    private _key = format ["%1:%2", _entryKind, toLower _className];

                                    if !(_key in _itemIndex) then {
                                        _ok = false;
                                        _message = format ["%1 is not available for this faction.", _className];
                                    } else {
                                        private _item = _itemIndex get _key;
                                        private _lineTotal = (_item get "priceValue") * _quantity;
                                        _total = _total + _lineTotal;

                                        if ([
                                            _item get "entryKind",
                                            _item get "category",
                                            _item get "priceValue"
                                        ] call FLO_fnc_storeDeploymentFundEligible) then {
                                            _deploymentEligibleTotal = _deploymentEligibleTotal + _lineTotal;
                                        };

                                        switch (_item get "entryKind") do {
                                            case "vehicle": {
                                                if !(_fobRecord get "vehicleStoreEnabled") then {
                                                    _ok = false;
                                                    _message = "Vehicles are not available at this base.";
                                                } else {
                                                    for "_vehicleIndex" from 1 to _quantity do {
                                                        _vehicleJobs pushBack createHashMapFromArray [
                                                            ["className", _item get "className"],
                                                            ["name", _item get "name"],
                                                            ["category", _item get "category"],
                                                            ["priceValue", _item get "priceValue"]
                                                        ];
                                                    };
                                                };
                                            };

                                            default {
                                                _gearEntries pushBack createHashMapFromArray [
                                                    ["className", _item get "className"],
                                                    ["name", _item get "name"],
                                                    ["category", _item get "category"],
                                                    ["container", _container],
                                                    ["quantity", _quantity],
                                                    ["slot", _slot]
                                                ];
                                            };
                                        };
                                    };
                                    };
                                };
                        };
                    };
                };
            };
        };
    };
};

if (!_ok) exitWith {
    createHashMapFromArray [
        ["success", false],
        ["message", _message],
        ["balance", FLO_ResourceBalances get _sideKey],
        ["deploymentFund", _deploymentFundRemaining],
        ["deploymentFundAmount", FLO_StoreDeploymentFundAmount],
        ["tickets", FLO_TicketBalances get _sideKey]
    ]
};

if (_total <= 0) exitWith {
    createHashMapFromArray [
        ["success", false],
        ["message", "Checkout total is invalid."],
        ["balance", FLO_ResourceBalances get _sideKey],
        ["deploymentFund", _deploymentFundRemaining],
        ["deploymentFundAmount", FLO_StoreDeploymentFundAmount],
        ["tickets", FLO_TicketBalances get _sideKey]
    ]
};

private _deploymentFundSpent = (_deploymentFundRemaining min _deploymentEligibleTotal) min _total;
private _factionTotal = _total - _deploymentFundSpent;

if ((_factionTotal > 0) && {!([_side, _factionTotal, "Store checkout"] call FLO_fnc_resourceSpend)}) exitWith {
    createHashMapFromArray [
        ["success", false],
        ["message", format ["Not enough faction currency. Required: %1.", _factionTotal]],
        ["balance", FLO_ResourceBalances get _sideKey],
        ["deploymentFund", _deploymentFundRemaining],
        ["deploymentFundAmount", FLO_StoreDeploymentFundAmount],
        ["tickets", FLO_TicketBalances get _sideKey]
    ]
};

if (_deploymentFundSpent > 0) then {
    _deploymentFundRemaining = _deploymentFundRemaining - _deploymentFundSpent;
    FLO_StoreDeploymentFunds set [_playerUid, _deploymentFundRemaining];
};

private _pendingVehicles = [];

{
    FLO_StorePendingVehicleCounter = FLO_StorePendingVehicleCounter + 1;

    private _purchaseId = format [
        "%1_%2_%3",
        _sideKey,
        floor (diag_tickTime * 1000),
        FLO_StorePendingVehicleCounter
    ];

    private _pending = createHashMapFromArray [
        ["id", _purchaseId],
        ["className", _x get "className"],
        ["name", _x get "name"],
        ["category", _x get "category"],
        ["priceValue", _x get "priceValue"],
        ["side", _side],
        ["sideKey", _sideKey],
        ["owner", _access get "owner"],
        ["playerUid", getPlayerUID (_access get "player")],
        ["fobNetId", _access get "fobNetId"],
        ["fobId", _fob getVariable ["FLO_FOB_Id", ""]],
        ["createdAt", diag_tickTime]
    ];

    FLO_StorePendingVehicles pushBack _pending;

    _pendingVehicles pushBack createHashMapFromArray [
        ["id", _purchaseId],
        ["className", _x get "className"],
        ["name", _x get "name"],
        ["category", _x get "category"],
        ["fobNetId", _access get "fobNetId"]
    ];
} forEach _vehicleJobs;

if (_gearEntries isNotEqualTo []) then {
    private _owner = _access get "owner";

    if (_owner <= 0) then {
        if (hasInterface) then {
            [_gearEntries] call FLO_fnc_storeApplyKit;
        };
    } else {
        [_gearEntries] remoteExecCall ["FLO_fnc_storeApplyKit", _owner];
    };
};

diag_log format [
    "[FLO][Store] %1 checkout player=%2 total=%3 deployment=%4 faction=%5 gear=%6 pendingVehicles=%7 balance=%8",
    _sideKey,
    name (_access get "player"),
    _total,
    _deploymentFundSpent,
    _factionTotal,
    count _gearEntries,
    count _pendingVehicles,
    FLO_ResourceBalances get _sideKey
];

["storeCheckout"] call FLO_fnc_persistenceScheduleSave;

createHashMapFromArray [
    ["success", true],
    ["message", format ["Purchased %1 gear lines and %2 vehicles for %3.", count _gearEntries, count _pendingVehicles, _total]],
    ["balance", FLO_ResourceBalances get _sideKey],
    ["deploymentFund", _deploymentFundRemaining],
    ["deploymentFundAmount", FLO_StoreDeploymentFundAmount],
    ["deploymentFundSpent", _deploymentFundSpent],
    ["factionSpent", _factionTotal],
    ["tickets", FLO_TicketBalances get _sideKey],
    ["spent", _total],
    ["gearCount", count _gearEntries],
    ["vehicleCount", count _pendingVehicles],
    ["pendingVehicles", [_access] call FLO_fnc_storePendingVehiclesForAccess]
]
