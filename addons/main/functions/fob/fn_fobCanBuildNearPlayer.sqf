params [["_unit", player]];

private _side = side group _unit;

if !(_side in [west, east]) exitWith {
    false
};

(count ([_side, getPosASL _unit] call FLO_fnc_fobBuildBaseAt)) > 0
