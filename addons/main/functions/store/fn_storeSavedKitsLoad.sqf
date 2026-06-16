if (!hasInterface) exitWith { [] };

private _kits = profileNamespace getVariable ["FLO_StoreSavedKits", []];

if ((typeName _kits) isNotEqualTo "ARRAY") exitWith { [] };

private _valid = [];

{
    if ((typeName _x) isNotEqualTo "HASHMAP") then { continue };
    if (!(("id" in _x) && {"name" in _x} && {"items" in _x})) then { continue };
    if ((typeName (_x get "id")) isNotEqualTo "STRING") then { continue };
    if ((typeName (_x get "name")) isNotEqualTo "STRING") then { continue };
    if ((typeName (_x get "items")) isNotEqualTo "ARRAY") then { continue };

    _valid pushBack _x;
} forEach _kits;

_valid
