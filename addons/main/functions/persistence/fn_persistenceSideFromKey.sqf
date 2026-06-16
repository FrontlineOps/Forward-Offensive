params ["_sideKey"];

if (_sideKey isEqualTo "WEST") exitWith { west };
if (_sideKey isEqualTo "EAST") exitWith { east };

sideUnknown
