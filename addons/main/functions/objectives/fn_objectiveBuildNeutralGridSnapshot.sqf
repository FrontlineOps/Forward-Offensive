private _cellSize = FLO_ObjectiveGridCellSize;
private _halfSize = _cellSize / 2;
private _gridWidth = ceil (worldSize / _cellSize);
private _gridHeight = ceil (worldSize / _cellSize);
private _snapshot = [];

for "_xIndex" from 0 to (_gridWidth - 1) do {
    for "_yIndex" from 0 to (_gridHeight - 1) do {
        private _id = [_xIndex, _yIndex] call FLO_fnc_objectiveGridCellId;
        private _xPos = (_xIndex * _cellSize) + _halfSize;
        private _yPos = (_yIndex * _cellSize) + _halfSize;
        private _position = [_xPos, _yPos, 0];

        if ([_position, _halfSize] call FLO_fnc_objectiveGridCellHasLand) then {
            _snapshot pushBack [
                _id,
                _position,
                _halfSize,
                "NONE",
                "neutral",
                0,
                "NONE",
                0,
                0
            ];
        };
    };
};

_snapshot
