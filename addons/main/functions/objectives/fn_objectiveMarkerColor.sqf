params ["_ownerKey", ["_state", "held"], ["_progressSideKey", "NONE"]];

if (_state isEqualTo "contested") exitWith { "ColorYellow" };

private _sideKey = _ownerKey;

if ((_state isEqualTo "capturing") && {_progressSideKey isNotEqualTo "NONE"}) then {
    _sideKey = _progressSideKey;
};

switch (_sideKey) do {
    case "EAST": { "ColorRed" };
    case "WEST": { "ColorBlue" };
    case "GUER": { "ColorGreen" };
    case "CIV": { "ColorWhite" };
    case "NONE": { "ColorGrey" };
    default {
        throw format ["[FLO][Objective] Unsupported marker owner key: %1", _sideKey];
    };
};
