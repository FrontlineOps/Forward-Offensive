params [
    "_cellId",
    ["_edgeBuffer", FLO_ObjectiveDeploymentEdgeBufferCells],
    ["_minCardinalNeighbors", FLO_ObjectiveDeploymentMinCardinalNeighbors],
    ["_roadRadius", FLO_ObjectiveDeploymentRoadRadius],
    ["_minObjectiveDistance", FLO_ObjectiveDeploymentMinObjectiveDistance],
    ["_minCenterDistanceRatio", FLO_ObjectiveDeploymentMinCenterDistanceRatio],
    ["_minSurfaceNormalZ", FLO_ObjectiveDeploymentMinSurfaceNormalZ],
    ["_requireRoad", true]
];

private _cell = FLO_ObjectiveCells get _cellId;
private _position = _cell get "position";
private _gridX = _cell get "gridX";
private _gridY = _cell get "gridY";
private _center = [worldSize / 2, worldSize / 2, 0];
private _neighborCount = count (_cell get "cardinalNeighborIds");

if (surfaceIsWater _position) exitWith { [] };
if (_neighborCount < _minCardinalNeighbors) exitWith { [] };
if ((_gridX < _edgeBuffer) || {_gridX > ((FLO_ObjectiveGridWidth - 1) - _edgeBuffer)}) exitWith { [] };
if ((_gridY < _edgeBuffer) || {_gridY > ((FLO_ObjectiveGridHeight - 1) - _edgeBuffer)}) exitWith { [] };
if ((_position distance2D _center) < (worldSize * _minCenterDistanceRatio)) exitWith { [] };

private _surfaceNormal = surfaceNormal _position;

if ((_surfaceNormal # 2) < _minSurfaceNormalZ) exitWith { [] };

private _roads = _position nearRoads _roadRadius;

if (_requireRoad && {(count _roads) isEqualTo 0}) exitWith { [] };

private _nearestRoadDistance = worldSize;

{
    _nearestRoadDistance = _nearestRoadDistance min (_position distance2D _x);
} forEach _roads;

private _nearestObjectiveDistance = worldSize;
private _objectiveAccessScores = [];

{
    private _objective = FLO_Objectives get _x;
    private _objectivePosition = _objective get "position";
    private _distance = _position distance2D _objectivePosition;
    private _weight = (_objective get "resourceWeight") max 1;

    _nearestObjectiveDistance = _nearestObjectiveDistance min _distance;
    _objectiveAccessScores pushBack [_distance / _weight, _distance, _weight];
} forEach keys FLO_Objectives;

if (_nearestObjectiveDistance < _minObjectiveDistance) exitWith { [] };

_objectiveAccessScores sort true;

private _objectiveAccessScore = worldSize;
private _objectiveAccessCount = (count _objectiveAccessScores) min 3;

if (_objectiveAccessCount > 0) then {
    private _totalAccess = 0;

    for "_i" from 0 to (_objectiveAccessCount - 1) do {
        _totalAccess = _totalAccess + ((_objectiveAccessScores # _i) # 0);
    };

    _objectiveAccessScore = _totalAccess / _objectiveAccessCount;
};

createHashMapFromArray [
    ["id", _cellId],
    ["position", _position],
    ["spawnASL", ATLToASL _position],
    ["gridX", _gridX],
    ["gridY", _gridY],
    ["neighborCount", _neighborCount],
    ["roadCount", count _roads],
    ["nearestRoadDistance", _nearestRoadDistance],
    ["nearestObjectiveDistance", _nearestObjectiveDistance],
    ["objectiveAccessScore", _objectiveAccessScore],
    ["centerDistance", _position distance2D _center]
]
