params ["_position"];

private _xIndex = floor ((_position # 0) / FLO_ObjectiveGridCellSize);
private _yIndex = floor ((_position # 1) / FLO_ObjectiveGridCellSize);

_xIndex = (_xIndex max 0) min (FLO_ObjectiveGridWidth - 1);
_yIndex = (_yIndex max 0) min (FLO_ObjectiveGridHeight - 1);

private _cellId = [_xIndex, _yIndex] call FLO_fnc_objectiveGridCellId;

if (_cellId in FLO_ObjectiveGridCellIdSet) exitWith {
    FLO_ObjectiveCells get _cellId
};

private _maxRing = FLO_ObjectiveGridWidth max FLO_ObjectiveGridHeight;
private _foundCellId = "";

for "_ring" from 1 to _maxRing do {
    for "_dx" from -_ring to _ring do {
        for "_dy" from -_ring to _ring do {
            if ((abs _dx isEqualTo _ring) || {abs _dy isEqualTo _ring}) then {
                private _candidateX = _xIndex + _dx;
                private _candidateY = _yIndex + _dy;

                if ((_candidateX >= 0) && {_candidateX < FLO_ObjectiveGridWidth} && {_candidateY >= 0} && {_candidateY < FLO_ObjectiveGridHeight}) then {
                    private _candidateId = [_candidateX, _candidateY] call FLO_fnc_objectiveGridCellId;

                    if (_candidateId in FLO_ObjectiveGridCellIdSet) exitWith {
                        _foundCellId = _candidateId;
                    };
                };
            };
        };

        if (_foundCellId isNotEqualTo "") exitWith {};
    };

    if (_foundCellId isNotEqualTo "") exitWith {};
};

if (_foundCellId isEqualTo "") then {
    throw format ["[FLO][Objective] No land grid cell found near position %1", _position];
};

FLO_ObjectiveCells get _foundCellId
