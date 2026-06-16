params ["_snapshot", "_sideKey"];

if !(_sideKey in ["WEST", "EAST"]) exitWith { [] };

private _row = [];

{
    if ((_x isEqualType []) && {(count _x) > 0} && {(_x # 0) isEqualTo _sideKey}) exitWith {
        _row = _x;
    };
} forEach _snapshot;

if (_row isEqualTo []) exitWith { [] };

[
    _row,
    _snapshot # 2,
    _snapshot # 3,
    _snapshot # 4
]
