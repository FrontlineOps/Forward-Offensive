params ["_cell", "_presence"];

private _position = _cell get "position";
private _radius = _cell get "radius";
private _owner = _cell get "owner";
private _state = _cell get "state";
private _progress = _cell get "progress";
private _progressSide = _cell get "progressSide";
private _oldOwner = _owner;
private _oldState = _state;
private _oldProgress = _progress;
private _oldProgressSide = _progressSide;
private _eastCount = 0;
private _westCount = 0;

{
    _x params ["_side", "_unitPosition"];

    if ((_unitPosition distance2D _position) <= _radius) then {
        if (_side isEqualTo east) then {
            _eastCount = _eastCount + 1;
        };

        if (_side isEqualTo west) then {
            _westCount = _westCount + 1;
        };
    };
} forEach _presence;

private _captureSide = sideUnknown;
private _eastPresent = _eastCount > 0;
private _westPresent = _westCount > 0;
private _captureStep = FLO_ObjectiveCellCaptureRate * FLO_ObjectiveUpdateInterval;
private _decayStep = FLO_ObjectiveCellDecayRate * FLO_ObjectiveUpdateInterval;

if (_eastPresent && _westPresent) then {
    _state = "contested";
} else {
    if (_eastCount >= FLO_ObjectiveMinCapturePlayers) then {
        _captureSide = east;
    };

    if (_westCount >= FLO_ObjectiveMinCapturePlayers) then {
        _captureSide = west;
    };

    if (_captureSide isEqualTo sideUnknown) then {
        if (_owner isEqualTo sideUnknown) then {
            _progress = (_progress - _decayStep) max 0;
            _state = ["neutral", "capturing"] select (_progress > 0);
        } else {
            _progress = 1;
            _progressSide = _owner;
            _state = "held";
        };
    } else {
        if (_owner isEqualTo _captureSide) then {
            _progress = 1;
            _progressSide = _captureSide;
            _state = "held";
        } else {
            if !(_progressSide isEqualTo _captureSide) then {
                _progress = 0;
                _progressSide = _captureSide;
            };

            _progress = (_progress + _captureStep) min 1;
            _state = "capturing";

            if (_progress >= 1) then {
                _owner = _captureSide;
                _state = "held";
            };
        };
    };
};

_cell set ["owner", _owner];
_cell set ["state", _state];
_cell set ["progress", _progress];
_cell set ["progressSide", _progressSide];
_cell set ["influenceEast", _eastCount];
_cell set ["influenceWest", _westCount];
_cell set ["lastEvaluated", diag_tickTime];

!(_oldOwner isEqualTo _owner) ||
{ !(_oldState isEqualTo _state) } ||
{ !(_oldProgressSide isEqualTo _progressSide) } ||
{ (abs (_oldProgress - _progress)) >= 0.01 }
