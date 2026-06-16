params ["_fob", "_className", "_category", ["_ordinal", 0, [0]]];

if (!isServer) exitWith {
    createHashMapFromArray [
        ["success", false],
        ["message", "Vehicle placement is server-owned."],
        ["position", []],
        ["direction", 0]
    ]
};

private _origin = getPosATL _fob;
private _baseDir = getDir _fob;
private _needsWater = (_category isEqualTo "naval") || {_className isKindOf "Ship"};
private _radius = FLO_StoreVehicleSpawnRadius;
private _found = false;
private _position = [];
private _direction = _baseDir;

for "_ring" from 0 to 4 do {
    if (_found) then { continue };

    private _distance = 14 + (_ring * 8) + ((_ordinal mod 4) * 3);

    if (_distance > _radius) then {
        _distance = _radius;
    };

    for "_step" from 0 to 23 do {
        if (_found) then { continue };

        private _angle = _baseDir + 30 + (_step * 15) + ((_ordinal mod 6) * 10);
        private _candidate = _origin getPos [_distance, _angle];

        if (_needsWater isNotEqualTo (surfaceIsWater _candidate)) then { continue };

        private _empty = _candidate findEmptyPosition [0, 8, _className];

        if (_empty isEqualTo []) then {
            _empty = _candidate;
        };

        if (_needsWater isNotEqualTo (surfaceIsWater _empty)) then { continue };

        _position = _empty;
        _direction = _angle + 180;
        _found = true;
    };
};

if (!_found) exitWith {
    createHashMapFromArray [
        ["success", false],
        ["message", format ["No clear spawn position found near the FOB for %1.", _className]],
        ["position", []],
        ["direction", 0]
    ]
};

createHashMapFromArray [
    ["success", true],
    ["message", ""],
    ["position", _position],
    ["direction", _direction]
]
