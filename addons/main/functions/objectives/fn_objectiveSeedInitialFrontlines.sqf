private _stages = [
    createHashMapFromArray [
        ["name", "strict"],
        ["edgeBuffer", FLO_ObjectiveDeploymentEdgeBufferCells],
        ["minNeighbors", FLO_ObjectiveDeploymentMinCardinalNeighbors],
        ["roadRadius", FLO_ObjectiveDeploymentRoadRadius],
        ["minObjectiveDistance", FLO_ObjectiveDeploymentMinObjectiveDistance],
        ["minCenterDistanceRatio", FLO_ObjectiveDeploymentMinCenterDistanceRatio],
        ["minSurfaceNormalZ", FLO_ObjectiveDeploymentMinSurfaceNormalZ],
        ["requireRoad", true],
        ["minPairDistanceRatio", FLO_ObjectiveDeploymentMinPairDistanceRatio],
        ["maxOppositionDot", FLO_ObjectiveDeploymentMaxOppositionDot],
        ["maxObjectiveAccessDelta", FLO_ObjectiveDeploymentMaxObjectiveAccessDelta]
    ],
    createHashMapFromArray [
        ["name", "relaxed"],
        ["edgeBuffer", 0],
        ["minNeighbors", 2],
        ["roadRadius", FLO_ObjectiveDeploymentRoadRadius * 1.75],
        ["minObjectiveDistance", FLO_ObjectiveDeploymentMinObjectiveDistance * 0.5],
        ["minCenterDistanceRatio", FLO_ObjectiveDeploymentMinCenterDistanceRatio * 0.5],
        ["minSurfaceNormalZ", 0.72],
        ["requireRoad", true],
        ["minPairDistanceRatio", FLO_ObjectiveDeploymentMinPairDistanceRatio * 0.75],
        ["maxOppositionDot", 0.15],
        ["maxObjectiveAccessDelta", 0.65]
    ],
    createHashMapFromArray [
        ["name", "fallback"],
        ["edgeBuffer", 0],
        ["minNeighbors", 1],
        ["roadRadius", FLO_ObjectiveDeploymentRoadRadius * 2.5],
        ["minObjectiveDistance", 0],
        ["minCenterDistanceRatio", 0],
        ["minSurfaceNormalZ", 0.55],
        ["requireRoad", false],
        ["minPairDistanceRatio", FLO_ObjectiveDeploymentMinPairDistanceRatio * 0.55],
        ["maxOppositionDot", 0.75],
        ["maxObjectiveAccessDelta", 1]
    ]
];

private _selectedStage = "";
private _candidates = [];
private _candidateById = createHashMap;
private _pairs = [];

{
    private _stage = _x;
    private _stageCandidates = [];
    private _stageCandidateById = createHashMap;

    {
        private _candidate = [
            _x,
            _stage get "edgeBuffer",
            _stage get "minNeighbors",
            _stage get "roadRadius",
            _stage get "minObjectiveDistance",
            _stage get "minCenterDistanceRatio",
            _stage get "minSurfaceNormalZ",
            _stage get "requireRoad"
        ] call FLO_fnc_objectiveBuildDeploymentCandidate;

        if (_candidate isNotEqualTo []) then {
            _stageCandidates pushBack _candidate;
            _stageCandidateById set [_candidate get "id", _candidate];
        };
    } forEach FLO_ObjectiveGridCellIds;

    if ((count _stageCandidates) >= 2) then {
        private _stagePairs = [];
        private _candidateCount = count _stageCandidates;

        for "_i" from 0 to (_candidateCount - 2) do {
            private _a = _stageCandidates # _i;

            for "_j" from (_i + 1) to (_candidateCount - 1) do {
                private _b = _stageCandidates # _j;
                private _score = [
                    _a,
                    _b,
                    _stage get "minPairDistanceRatio",
                    _stage get "maxOppositionDot",
                    _stage get "maxObjectiveAccessDelta"
                ] call FLO_fnc_objectiveScoreDeploymentPair;

                if (_score isNotEqualTo []) then {
                    _stagePairs pushBack _score;
                };
            };
        };

        if (_stagePairs isNotEqualTo []) exitWith {
            _selectedStage = _stage get "name";
            _candidates = _stageCandidates;
            _candidateById = _stageCandidateById;
            _pairs = _stagePairs;
        };
    };
} forEach _stages;

if ((count _pairs) isEqualTo 0) then {
    throw format [
        "[FLO][Objective] No valid deployment pairs from %1 grid cells after staged selection",
        count FLO_ObjectiveGridCellIds
    ];
};

_pairs sort true;

private _topCount = (count _pairs) min FLO_ObjectiveDeploymentTopPairCount;
private _selectedPair = _pairs # (floor random _topCount);
private _a = _candidateById get (_selectedPair # 2);
private _b = _candidateById get (_selectedPair # 3);
private _swapSides = (random 1) >= 0.5;
private _westCandidate = [_a, _b] select _swapSides;
private _eastCandidate = [_b, _a] select _swapSides;
private _westPosition = _westCandidate get "position";
private _eastPosition = _eastCandidate get "position";
private _westSeedId = _westCandidate get "id";
private _eastSeedId = _eastCandidate get "id";
private _westCellIds = [_westSeedId] call FLO_fnc_objectiveDeploymentEntryCells;
private _eastCellIds = [_eastSeedId] call FLO_fnc_objectiveDeploymentEntryCells;
private _westDir = [_westPosition, _eastPosition] call BIS_fnc_dirTo;
private _eastDir = [_eastPosition, _westPosition] call BIS_fnc_dirTo;

FLO_DeploymentZones = createHashMapFromArray [
    [
        "WEST",
        createHashMapFromArray [
            ["side", west],
            ["sideKey", "WEST"],
            ["cellId", _westSeedId],
            ["entryCellIds", _westCellIds],
            ["position", _westPosition],
            ["spawnASL", _westCandidate get "spawnASL"],
            ["dir", _westDir],
            ["pairScore", _selectedPair # 0]
        ]
    ],
    [
        "EAST",
        createHashMapFromArray [
            ["side", east],
            ["sideKey", "EAST"],
            ["cellId", _eastSeedId],
            ["entryCellIds", _eastCellIds],
            ["position", _eastPosition],
            ["spawnASL", _eastCandidate get "spawnASL"],
            ["dir", _eastDir],
            ["pairScore", _selectedPair # 0]
        ]
    ]
];

FLO_ObjectiveInitialFrontlineCellIds = createHashMapFromArray [
    ["WEST", _westCellIds],
    ["EAST", _eastCellIds]
];

FLO_DeploymentPairDiagnostics = createHashMapFromArray [
    ["stage", _selectedStage],
    ["candidateCount", count _candidates],
    ["pairCount", count _pairs],
    ["topCount", _topCount],
    ["score", _selectedPair # 0],
    ["pairDistance", _selectedPair # 4],
    ["oppositionDot", _selectedPair # 5],
    ["objectiveAccessParity", _selectedPair # 6]
];

diag_log format [
    "[FLO][Objective] Generated deployment zones stage=%1 west=%2 east=%3 westCount=%4 eastCount=%5 candidates=%6 pairs=%7 top=%8 score=%9 distance=%10",
    _selectedStage,
    _westSeedId,
    _eastSeedId,
    count _westCellIds,
    count _eastCellIds,
    count _candidates,
    count _pairs,
    _topCount,
    _selectedPair # 0,
    _selectedPair # 4
];

_westCellIds + _eastCellIds
