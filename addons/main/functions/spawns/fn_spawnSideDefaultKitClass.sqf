params ["_sideKey"];

if (!isServer) exitWith { "" };

private _state = FLO_CommandSideState get _sideKey;
private _factionClass = _state get "factionClass";

if (_factionClass isEqualTo "") exitWith { "" };

private _cacheKey = format ["%1:%2", _sideKey, toLower _factionClass];

if (_cacheKey in FLO_SpawnDefaultKitCache) exitWith {
    FLO_SpawnDefaultKitCache get _cacheKey
};

private _groupCandidates = [_sideKey, _factionClass] call FLO_fnc_spawnFactionGroupUnitClasses;
private _fallbackCandidates = [];
private _seen = createHashMap;

{
    _seen set [_x, true];
} forEach _groupCandidates;

{
    private _unitCfg = _x;
    private _unitClass = configName _unitCfg;

    if (_unitClass in _seen) then { continue };
    if ((toLower (getText (_unitCfg >> "faction"))) isNotEqualTo (toLower _factionClass)) then { continue };
    if ((getNumber (_unitCfg >> "scope")) < 2) then { continue };
    if !(_unitClass isKindOf "CAManBase") then { continue };

    _seen set [_unitClass, true];
    _fallbackCandidates pushBack _unitClass;
} forEach ("true" configClasses (configFile >> "CfgVehicles"));

private _defaultKitClass = "";

{
    if ([_x, _factionClass, true] call FLO_fnc_spawnUnitClassCanBeBaseKit) exitWith {
        _defaultKitClass = _x;
    };
} forEach _groupCandidates;

if (_defaultKitClass isEqualTo "") then {
    {
        if ([_x, _factionClass] call FLO_fnc_spawnUnitClassCanBeBaseKit) exitWith {
            _defaultKitClass = _x;
        };
    } forEach _fallbackCandidates;
};

FLO_SpawnDefaultKitCache set [_cacheKey, _defaultKitClass];

if (_defaultKitClass isEqualTo "") then {
    diag_log format [
        "[FLO][Spawn] No base kit found for side=%1 faction=%2 groupCandidates=%3 fallbackCandidates=%4",
        _sideKey,
        _factionClass,
        count _groupCandidates,
        count _fallbackCandidates
    ];
} else {
    diag_log format [
        "[FLO][Spawn] Selected base kit side=%1 faction=%2 unit=%3 name=%4",
        _sideKey,
        _factionClass,
        _defaultKitClass,
        getText (configFile >> "CfgVehicles" >> _defaultKitClass >> "displayName")
    ];
};

_defaultKitClass
