params ["_snapshot", "_sideKey", ["_uid", ""]];

if !(_sideKey in ["WEST", "EAST"]) exitWith { [] };

private _row = [];

{
    if ((_x isEqualType []) && {(count _x) > 0} && {(_x # 0) isEqualTo _sideKey}) exitWith {
        _row = _x;
    };
} forEach _snapshot;

if (_row isEqualTo []) exitWith { [] };

private _scopedRow = +_row;
private _personalBalance = [_sideKey, _uid] call FLO_fnc_resourcePersonalBalance;

_scopedRow pushBack _personalBalance;
_scopedRow pushBack FLO_ResourceFactionIncomeShare;
_scopedRow pushBack FLO_ResourcePersonalIncomeShare;

[
    _scopedRow,
    _snapshot # 2,
    _snapshot # 3,
    _snapshot # 4
]
