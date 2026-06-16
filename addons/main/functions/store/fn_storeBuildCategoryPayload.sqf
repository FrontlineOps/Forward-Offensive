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

private _catalog = [
    _access get "sideKey",
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
    ["balance", FLO_ResourceBalances get (_access get "sideKey")],
    ["tickets", FLO_TicketBalances get (_access get "sideKey")]
]
