params ["_sideKey", "_factionClass"];

private _sideName = switch (_sideKey) do {
    case "WEST": { "West" };
    case "EAST": { "East" };
    default { "" };
};

if (_sideName isEqualTo "") exitWith { [] };

private _root = configFile >> "CfgGroups" >> _sideName >> _factionClass;

if !(isClass _root) exitWith { [] };

private _classes = [];
private _seen = createHashMap;
private _stack = [];

for "_i" from 0 to ((count _root) - 1) do {
    private _child = _root select _i;
    if (isClass _child) then {
        _stack pushBack _child;
    };
};

while {_stack isNotEqualTo []} do {
    private _cfg = _stack deleteAt 0;

    if (isText (_cfg >> "vehicle")) then {
        private _unitClass = getText (_cfg >> "vehicle");

        if ((_unitClass isNotEqualTo "") && {!(_unitClass in _seen)}) then {
            _seen set [_unitClass, true];
            _classes pushBack _unitClass;
        };
    };

    for "_i" from 0 to ((count _cfg) - 1) do {
        private _child = _cfg select _i;
        if (isClass _child) then {
            _stack pushBack _child;
        };
    };
};

_classes
