params ["_cell", ["_slot", 0, [0]], ["_className", "B_Soldier_F", [""]], ["_throwOnFail", false, [false]]];

private _cellId = _cell get "id";
private _center = _cell get "position";
private _halfSize = _cell get "halfSize";
private _maxOffset = (_halfSize - 35) max 0;
private _preferredRadius = 0;
private _preferredAngle = 0;

if (_slot > 0) then {
    _preferredRadius = 8 + (floor ((_slot - 1) / 8)) * 8;
    _preferredAngle = ((_slot - 1) mod 8) * 45;
};

private _radii = [];
private _result = [];

if (_slot isEqualTo 0) then {
    _radii pushBack 0;
};

if (_preferredRadius > 0) then {
    _radii pushBackUnique (_preferredRadius min _maxOffset);
};

{
    _radii pushBackUnique (_x min _maxOffset);
} forEach [25, 50, 100, 175, 250, 350, 450];

if (_slot > 0) then {
    _radii pushBackUnique 0;
};

{
    if (_result isNotEqualTo []) then {
        continue;
    };

    private _radius = _x;
    private _angleSteps = [1, 16] select (_radius > 0);

    for "_i" from 0 to (_angleSteps - 1) do {
        private _angle = _preferredAngle + (_i * 22.5);
        private _candidate = [
            (_center # 0) + ((sin _angle) * _radius),
            (_center # 1) + ((cos _angle) * _radius),
            0
        ];

        if (([_candidate] call FLO_fnc_objectiveGridCellIdAtPosition) isNotEqualTo _cellId) then {
            continue;
        };

        if (surfaceIsWater _candidate) then {
            continue;
        };

        private _empty = _candidate findEmptyPosition [0, 12, _className];

        if (_empty isEqualTo []) then {
            _empty = _candidate;
        };

        _empty set [2, 0];

        if ((([_empty] call FLO_fnc_objectiveGridCellIdAtPosition) isEqualTo _cellId) && {!(surfaceIsWater _empty)}) exitWith {
            _result = _empty;
        };
    };
} forEach _radii;

if (_result isNotEqualTo []) exitWith {
    _result
};

if (_throwOnFail) then {
    throw format ["[FLO][Spawn] No dry deployment spawn position in cell %1 center=%2 slot=%3", _cellId, _center, _slot];
};

[]
