params ["_side"];

if (_side isEqualTo west) exitWith { "WEST" };
if (_side isEqualTo east) exitWith { "EAST" };

"UNKNOWN"
