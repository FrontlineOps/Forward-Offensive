params ["_itemsByCategory", "_seen"];

private _loadedSources = createHashMap;

{
    _x params ["_sourceName"];
    _loadedSources set [_sourceName, [_x] call FLO_fnc_storeSupportSourceLoaded];
} forEach FLO_StoreSupportModSources;

{
    _x params ["_className", "_entryKind", "_category"];

    if ([_className] call FLO_fnc_storeSupportClassRejected) then { continue };

    private _cfg = configNull;

    if (_entryKind isEqualTo "vehicle") then {
        _cfg = configFile >> "CfgVehicles" >> _className;
    } else {
        if (_category in ["ammo", "mines"]) then {
            _cfg = configFile >> "CfgMagazines" >> _className;
        } else {
            if (_category isEqualTo "backpacks") then {
                _cfg = configFile >> "CfgVehicles" >> _className;
            } else {
                if (_category isEqualTo "facewear") then {
                    _cfg = configFile >> "CfgGlasses" >> _className;
                } else {
                    if ((_category isEqualTo "misc") && {isClass (configFile >> "CfgMagazines" >> _className)} && {!(isClass (configFile >> "CfgWeapons" >> _className))}) then {
                        _cfg = configFile >> "CfgMagazines" >> _className;
                    } else {
                        _cfg = configFile >> "CfgWeapons" >> _className;
                    };
                };
            };
        };
    };

    private _sourceIndex = FLO_StoreSupportModSources findIf {
        _x params ["_sourceName", "_patches", "_addons", "_prefixes", "_contains", "_categories"];

        (_category in _categories)
        && {
            ([_className, _prefixes, "prefix"] call FLO_fnc_storeStringMatchesPatterns)
            || {[_className, _contains, "contains"] call FLO_fnc_storeStringMatchesPatterns}
            || {(!isNull _cfg) && {[_cfg, _x] call FLO_fnc_storeSupportConfigMatchesSource}}
        }
    };

    if (_sourceIndex >= 0) then {
        private _source = FLO_StoreSupportModSources select _sourceIndex;
        _source params ["_sourceName"];

        if !(_loadedSources get _sourceName) then { continue };
    };

    [_itemsByCategory, _seen, _className, _entryKind, _category] call FLO_fnc_storeAppendCatalogItem;
} forEach FLO_StoreSupportCatalogItems;
