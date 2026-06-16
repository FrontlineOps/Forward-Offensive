params ["_id"];

if (!hasInterface) exitWith {
    createHashMapFromArray [
        ["success", false],
        ["message", "Saved kits are client-local."],
        ["kits", []]
    ]
};

if ((typeName _id) isNotEqualTo "STRING") exitWith {
    createHashMapFromArray [
        ["success", false],
        ["message", "Invalid saved kit id."],
        ["kits", [] call FLO_fnc_storeSavedKitsLoad]
    ]
};

private _next = [];

{
    if ((_x get "id") isNotEqualTo _id) then {
        _next pushBack _x;
    };
} forEach ([] call FLO_fnc_storeSavedKitsLoad);

profileNamespace setVariable ["FLO_StoreSavedKits", _next];
saveProfileNamespace;

createHashMapFromArray [
    ["success", true],
    ["message", "Deleted saved kit."],
    ["kits", [] call FLO_fnc_storeSavedKitsLoad]
]
