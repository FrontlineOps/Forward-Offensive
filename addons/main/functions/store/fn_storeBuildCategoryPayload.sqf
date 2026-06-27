params ["_access", "_category"];

private _valid = false;
private _label = _category;

{
    if ((_x select 0) isEqualTo _category) then {
        _valid = true;
        _label = _x select 1;
    };
} forEach FLO_StoreCategories;

if (!_valid) exitWith {
    createHashMapFromArray [
        ["success", false],
        ["message", format ["Unknown store category: %1", _category]],
        ["category", _category],
        ["label", _label],
        ["items", []]
    ]
};

private _sideKey = _access get "sideKey";
private _fobRecord = _access get "fobRecord";
private _baseType = _fobRecord get "type";
private _vehicleStoreEnabled = _fobRecord get "vehicleStoreEnabled";
private _playerUid = getPlayerUID (_access get "player");
private _deploymentFund = [_playerUid] call FLO_fnc_storeDeploymentFundBalance;
private _personalBalance = [_sideKey, _playerUid] call FLO_fnc_resourcePersonalBalance;
private _canUseFactionFunds = [_access get "player"] call FLO_fnc_commandPlayerIsCommanderOrDeputy;

if (!_vehicleStoreEnabled && {_category in FLO_StoreVehicleCategories}) exitWith {
    createHashMapFromArray [
        ["success", true],
        ["message", "Vehicles are not available at this base."],
        ["category", _category],
        ["label", _label],
        ["items", []],
        ["baseType", _baseType],
        ["vehicleStoreEnabled", _vehicleStoreEnabled],
        ["balance", FLO_ResourceBalances get _sideKey],
        ["personalBalance", _personalBalance],
        ["canUseFactionFunds", _canUseFactionFunds],
        ["deploymentFund", _deploymentFund],
        ["deploymentFundAmount", FLO_StoreDeploymentFundAmount],
        ["tickets", FLO_TicketBalances get _sideKey]
    ]
};

private _catalog = [
    _sideKey,
    _access get "factionClass",
    _access get "factionName"
] call FLO_fnc_storeBuildCatalog;
private _itemsByCategory = _catalog get "itemsByCategory";

createHashMapFromArray [
    ["success", true],
    ["message", ""],
    ["category", _category],
    ["label", _label],
    ["items", _itemsByCategory get _category],
    ["baseType", _baseType],
    ["vehicleStoreEnabled", _vehicleStoreEnabled],
    ["balance", FLO_ResourceBalances get _sideKey],
    ["personalBalance", _personalBalance],
    ["canUseFactionFunds", _canUseFactionFunds],
    ["deploymentFund", _deploymentFund],
    ["deploymentFundAmount", FLO_StoreDeploymentFundAmount],
    ["tickets", FLO_TicketBalances get _sideKey]
]
