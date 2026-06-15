params ["_side"];

if (_side isEqualTo east) exitWith { "EAST" };
if (_side isEqualTo west) exitWith { "WEST" };
if (_side isEqualTo resistance) exitWith { "GUER" };
if (_side isEqualTo civilian) exitWith { "CIV" };
if (_side isEqualTo sideUnknown) exitWith { "NONE" };

throw format ["[FLO][Objective] Unsupported side for objective snapshot: %1", _side];
