params ["_access"];

private _sideKey = _access get "sideKey";
private _playerUid = getPlayerUID (_access get "player");
private _fobRecord = _access get "fobRecord";
private _baseType = _fobRecord get "type";
private _vehicleStoreEnabled = _fobRecord get "vehicleStoreEnabled";
private _deploymentFund = [_playerUid] call FLO_fnc_storeDeploymentFundBalance;
private _catalog = [
    _sideKey,
    _access get "factionClass",
    _access get "factionName"
] call FLO_fnc_storeBuildCatalog;
private _itemsByCategory = _catalog get "itemsByCategory";
private _categories = [];
private _firstCategory = "";

{
    private _category = _x select 0;
    private _label = _x select 1;

    if (!_vehicleStoreEnabled && {_category in FLO_StoreVehicleCategories}) then { continue };

    private _count = count (_itemsByCategory get _category);

    _categories pushBack createHashMapFromArray [
        ["id", _category],
        ["label", _label],
        ["count", _count]
    ];

    if ((_firstCategory isEqualTo "") && {_count > 0}) then {
        _firstCategory = _category;
    };
} forEach FLO_StoreCategories;

createHashMapFromArray [
    ["success", true],
    ["message", ""],
    ["sideKey", _sideKey],
    ["sideName", ["BLUFOR", "OPFOR"] select (_sideKey isEqualTo "EAST")],
    ["factionClass", _catalog get "factionClass"],
    ["factionName", _catalog get "factionName"],
    ["baseType", _baseType],
    ["vehicleStoreEnabled", _vehicleStoreEnabled],
    ["balance", FLO_ResourceBalances get _sideKey],
    ["deploymentFund", _deploymentFund],
    ["deploymentFundAmount", FLO_StoreDeploymentFundAmount],
    ["tickets", FLO_TicketBalances get _sideKey],
    ["categories", _categories],
    ["firstCategory", _firstCategory],
    ["fobNetId", _access get "fobNetId"],
    ["pendingVehicles", [_access] call FLO_fnc_storePendingVehiclesForAccess]
]
