params ["_ownerByCell"];

private _changedCellIds = [];
private _influenceStep = FLO_ObjectiveGridInfluenceRate * FLO_ObjectiveUpdateInterval;
private _encirclementStep = FLO_ObjectiveGridEncirclementRate * FLO_ObjectiveUpdateInterval;

{
    private _cell = FLO_ObjectiveCells get _x;
    private _eastPresent = (_cell get "influenceEast") > 0;
    private _westPresent = (_cell get "influenceWest") > 0;

    if (!_eastPresent && {!_westPresent}) then {
        private _owner = _cell get "owner";
        private _state = _cell get "state";
        private _progress = _cell get "progress";
        private _progressSide = _cell get "progressSide";
        private _oldOwner = _owner;
        private _oldState = _state;
        private _oldProgress = _progress;
        private _oldProgressSide = _progressSide;
        private _targetSide = [_cell, _ownerByCell] call FLO_fnc_objectivePassiveTargetSide;
        private _step = [_encirclementStep, _influenceStep] select (_owner isEqualTo sideUnknown);

        if ((_targetSide isNotEqualTo sideUnknown) && {[_cell, _targetSide] call FLO_fnc_objectiveAnchorCaptureAllowed}) then {
            if (_progressSide isNotEqualTo _targetSide) then {
                _progress = 0;
                _progressSide = _targetSide;
            };

            _progress = (_progress + _step) min 1;
            _state = "capturing";

            if (_progress >= 1) then {
                _owner = _targetSide;
                _state = "held";
            };

            _cell set ["owner", _owner];
            _cell set ["state", _state];
            _cell set ["progress", _progress];
            _cell set ["progressSide", _progressSide];

            if ((_oldOwner isNotEqualTo _owner) ||
                { _oldState isNotEqualTo _state } ||
                { _oldProgressSide isNotEqualTo _progressSide } ||
                { (abs (_oldProgress - _progress)) >= 0.01 }) then {
                _changedCellIds pushBack _x;
            };
        };
    };
} forEach FLO_ObjectiveGridCellIds;

_changedCellIds
