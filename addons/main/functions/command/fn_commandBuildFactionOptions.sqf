params ["_side"];

private _targetSide = if (_side isEqualTo west) then {
    1
} else {
    if (_side isEqualTo east) then {
        0
    } else {
        throw format ["[FLO][Command] Unsupported faction option side: %1", _side];
    };
};

private _sideKey = [_side] call FLO_fnc_resourceSideKey;
private _sideName = ["East", "West"] select (_side isEqualTo west);
private _factions = createHashMap;
private _unitCounts = createHashMap;
private _vehicleCounts = createHashMap;
private _groupCounts = createHashMap;
private _blacklist = createHashMapFromArray [
    ["virtual_f", true],
    ["interactive_f", true]
];

{
    private _root = _x;
    if (isClass _root) then {
        for "_i" from 0 to ((count _root) - 1) do {
            private _facCfg = _root select _i;
            if !(isClass _facCfg) then { continue };
            if !(isNumber (_facCfg >> "side")) then { continue };

            private _className = configName _facCfg;
            private _classLower = toLower _className;

            if (_classLower in _factions) then { continue };
            if (_classLower in _blacklist) then { continue };
            if ((getNumber (_facCfg >> "side")) isNotEqualTo _targetSide) then { continue };

            private _displayName = getText (_facCfg >> "displayName");
            if (_displayName isEqualTo "") then {
                _displayName = _className;
            };

            _factions set [
                _classLower,
                createHashMapFromArray [
                    ["class", _className],
                    ["displayName", _displayName]
                ]
            ];
        };
    };
} forEach [
    missionConfigFile >> "CfgFactionClasses",
    configFile >> "CfgFactionClasses"
];

private _groupsRoot = configFile >> "CfgGroups" >> _sideName;
if (isClass _groupsRoot) then {
    for "_i" from 0 to ((count _groupsRoot) - 1) do {
        private _facGroups = _groupsRoot select _i;
        if !(isClass _facGroups) then { continue };

        private _classLower = toLower (configName _facGroups);
        if !(_classLower in _factions) then { continue };

        private _count = 0;
        if (_classLower in _groupCounts) then {
            _count = _groupCounts get _classLower;
        };
        _groupCounts set [_classLower, _count + count _facGroups];
    };
};

{
    private _vehCfg = _x;
    private _faction = getText (_vehCfg >> "faction");
    if (_faction isEqualTo "") then { continue };

    private _factionLower = toLower _faction;
    if !(_factionLower in _factions) then { continue };
    if ((getNumber (_vehCfg >> "scope")) < 2) then { continue };

    private _counts = [_vehicleCounts, _unitCounts] select ((configName _vehCfg) isKindOf "Man");

    private _count = 0;
    if (_factionLower in _counts) then {
        _count = _counts get _factionLower;
    };
    _counts set [_factionLower, _count + 1];
} forEach ("true" configClasses (configFile >> "CfgVehicles"));

private _options = [];

{
    private _classLower = _x;
    private _meta = _y;
    private _unitCount = 0;

    if (_classLower in _unitCounts) then {
        _unitCount = _unitCounts get _classLower;
    };

    if (_unitCount <= 0) then { continue };

    private _vehicleCount = 0;
    if (_classLower in _vehicleCounts) then {
        _vehicleCount = _vehicleCounts get _classLower;
    };

    private _groupCount = 0;
    if (_classLower in _groupCounts) then {
        _groupCount = _groupCounts get _classLower;
    };

    _options pushBack createHashMapFromArray [
        ["class", _meta get "class"],
        ["displayName", _meta get "displayName"],
        ["sideKey", _sideKey],
        ["unitCount", _unitCount],
        ["vehicleCount", _vehicleCount],
        ["groupCount", _groupCount],
        ["compatibility", ["CfgVehicles", "CfgGroups"] select (_groupCount > 0)]
    ];
} forEach _factions;

[_options, [], { _x get "displayName" }, "ASCEND"] call BIS_fnc_sortBy
