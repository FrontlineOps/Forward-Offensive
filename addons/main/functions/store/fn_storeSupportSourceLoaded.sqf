params ["_source"];

_source params ["_sourceName", "_patches", "_addons", "_prefixes", "_contains", "_categories"];

if (_patches isEqualTo []) exitWith {
    true
};

private _loaded = false;

{
    private _patchPattern = _x;
    private _patchIndex = ("true" configClasses (configFile >> "CfgPatches")) findIf {
        [configName _x, [_patchPattern], "prefix"] call FLO_fnc_storeStringMatchesPatterns
    };

    if (_patchIndex >= 0) exitWith {
        _loaded = true;
    };
} forEach _patches;

_loaded
