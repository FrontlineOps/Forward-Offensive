params ["_source"];

_source params ["_sourceName", "_patches", "_addons", "_prefixes", "_contains", "_categories"];

if (_patches isEqualTo []) exitWith {
    true
};

if ((_patches findIf {
    isClass (configFile >> "CfgPatches" >> _x)
}) >= 0) exitWith {
    true
};

private _patchPatterns = [];
_patchPatterns append _addons;
_patchPatterns append _prefixes;
_patchPatterns append _contains;

(("true" configClasses (configFile >> "CfgPatches")) findIf {
    private _patchName = configName _x;

    ([_patchName, _patchPatterns, "prefix"] call FLO_fnc_storeStringMatchesPatterns)
        || {[_patchName, _contains, "contains"] call FLO_fnc_storeStringMatchesPatterns}
}) >= 0
