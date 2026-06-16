params [
    "_a",
    "_b",
    ["_minPairDistanceRatio", FLO_ObjectiveDeploymentMinPairDistanceRatio],
    ["_maxOppositionDot", FLO_ObjectiveDeploymentMaxOppositionDot],
    ["_maxObjectiveAccessDelta", FLO_ObjectiveDeploymentMaxObjectiveAccessDelta]
];

private _posA = _a get "position";
private _posB = _b get "position";
private _center = [worldSize / 2, worldSize / 2, 0];
private _pairDistance = _posA distance2D _posB;

if (_pairDistance < (worldSize * _minPairDistanceRatio)) exitWith { [] };

private _aCenterDistance = _a get "centerDistance";
private _bCenterDistance = _b get "centerDistance";
private _aVecX = (_posA # 0) - (_center # 0);
private _aVecY = (_posA # 1) - (_center # 1);
private _bVecX = (_posB # 0) - (_center # 0);
private _bVecY = (_posB # 1) - (_center # 1);
private _dot = ((_aVecX * _bVecX) + (_aVecY * _bVecY)) / (_aCenterDistance * _bCenterDistance);

if (_dot > _maxOppositionDot) exitWith { [] };

private _accessA = _a get "objectiveAccessScore";
private _accessB = _b get "objectiveAccessScore";
private _accessParity = (abs (_accessA - _accessB)) / ((_accessA + _accessB) max 1);

if (_accessParity > _maxObjectiveAccessDelta) exitWith { [] };

private _targetDistance = worldSize * FLO_ObjectiveDeploymentTargetPairDistanceRatio;
private _score = 0;

_score = _score + ((abs (_pairDistance - _targetDistance)) / FLO_ObjectiveGridCellSize) * 12;
_score = _score + ((abs (_aCenterDistance - _bCenterDistance)) / FLO_ObjectiveGridCellSize) * 8;
_score = _score + ((1 + _dot) * 80);
_score = _score + (_accessParity * 120);
_score = _score + ((abs ((_a get "neighborCount") - (_b get "neighborCount"))) * 10);
_score = _score + ((abs ((_a get "nearestRoadDistance") - (_b get "nearestRoadDistance"))) / 100);
_score = _score + ((abs ((_a get "roadCount") - (_b get "roadCount"))) * 2);

[
    _score,
    random 1,
    _a get "id",
    _b get "id",
    _pairDistance,
    _dot,
    _accessParity
]
