params ["_side"];

if ((typeName _side) isEqualTo "STRING") then {
    private _sideKey = toUpper _side;

    if (_sideKey in ["WEST", "EAST"]) exitWith { _sideKey };
};

if (_side isEqualTo west) exitWith { "WEST" };
if (_side isEqualTo east) exitWith { "EAST" };

throw format ["[FLO][Resource] Unsupported resource side: %1", _side];
