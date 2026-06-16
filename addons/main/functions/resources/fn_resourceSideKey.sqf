params ["_side"];

if (_side isEqualTo west) exitWith { "WEST" };
if (_side isEqualTo east) exitWith { "EAST" };

throw format ["[FLO][Resource] Unsupported resource side: %1", _side];
