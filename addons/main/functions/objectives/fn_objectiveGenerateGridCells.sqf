private _cellSize = FLO_ObjectiveGridCellSize;
private _halfSize = _cellSize / 2;
private _gridWidth = ceil (worldSize / _cellSize);
private _gridHeight = ceil (worldSize / _cellSize);
private _cells = [];
private _landGrid = [];

FLO_ObjectiveGridWidth = _gridWidth;
FLO_ObjectiveGridHeight = _gridHeight;
FLO_ObjectiveGridCellIds = [];
FLO_ObjectiveGridCellIdSet = createHashMap;

for "_xIndex" from 0 to (_gridWidth - 1) do {
    private _row = [];

    for "_yIndex" from 0 to (_gridHeight - 1) do {
        _row pushBack false;
    };

    _landGrid pushBack _row;
};

for "_xIndex" from 0 to (_gridWidth - 1) do {
    for "_yIndex" from 0 to (_gridHeight - 1) do {
        private _id = [_xIndex, _yIndex] call FLO_fnc_objectiveGridCellId;
        private _xPos = (_xIndex * _cellSize) + _halfSize;
        private _yPos = (_yIndex * _cellSize) + _halfSize;
        private _position = [_xPos, _yPos, 0];

        if ([_position, _halfSize] call FLO_fnc_objectiveGridCellHasLand) then {
            (_landGrid # _xIndex) set [_yIndex, true];

            _cells pushBack createHashMapFromArray [
                ["id", _id],
                ["objectiveId", ""],
                ["role", "grid"],
                ["position", _position],
                ["radius", _halfSize],
                ["halfSize", _halfSize],
                ["weight", 1],
                ["gridX", _xIndex],
                ["gridY", _yIndex],
                ["neighborIds", []],
                ["cardinalNeighborIds", []],
                ["owner", sideUnknown],
                ["state", "neutral"],
                ["progress", 0],
                ["progressSide", sideUnknown],
                ["influenceEast", 0],
                ["influenceWest", 0],
                ["lastEvaluated", 0]
            ];

            FLO_ObjectiveGridCellIds pushBack _id;
            FLO_ObjectiveGridCellIdSet set [_id, true];
        };
    };
};

{
    private _xIndex = _x get "gridX";
    private _yIndex = _x get "gridY";
    private _neighborIds = [];
    private _cardinalNeighborIds = [];

    for "_dx" from -1 to 1 do {
        for "_dy" from -1 to 1 do {
            if (!((_dx isEqualTo 0) && {_dy isEqualTo 0})) then {
                private _neighborX = _xIndex + _dx;
                private _neighborY = _yIndex + _dy;

                if ((_neighborX >= 0) && {_neighborX < _gridWidth} && {_neighborY >= 0} && {_neighborY < _gridHeight} && {(_landGrid # _neighborX) # _neighborY}) then {
                    private _neighborId = [_neighborX, _neighborY] call FLO_fnc_objectiveGridCellId;

                    _neighborIds pushBack _neighborId;

                    if (((abs _dx) + (abs _dy)) isEqualTo 1) then {
                        _cardinalNeighborIds pushBack _neighborId;
                    };
                };
            };
        };
    };

    _x set ["neighborIds", _neighborIds];
    _x set ["cardinalNeighborIds", _cardinalNeighborIds];
} forEach _cells;

diag_log format [
    "[FLO][Objective] Generated %1 grid cells size=%2 worldSize=%3",
    count _cells,
    _cellSize,
    worldSize
];

_cells
