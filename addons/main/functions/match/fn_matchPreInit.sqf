FLO_MatchSetupDuration = 600;
FLO_MatchFrontlineDuration = 600;
FLO_MatchOperationDuration = 3600;
FLO_MatchTickInterval = 10;
FLO_MatchSnapshotHeartbeat = 60;

FLO_MatchObjectiveScore = 60;
FLO_MatchCaptureSwingScore = 30;
FLO_MatchSecondaryObjectiveScore = 25;
FLO_MatchSecondaryCaptureSwingScore = 12;
FLO_MatchSectorPresenceScorePerPlayerMinute = 1;
FLO_MatchCellGainScore = 2;
FLO_MatchTicketDrainScore = 2;
FLO_MatchWinnerTicketReward = 5;
FLO_MatchWinnerFreeUpgradeReward = 1;

FLO_MatchSnapshot = createHashMap;
FLO_MatchLastAnnouncedPhaseKey = "";
FLO_MatchDialogIdd = 9400;
FLO_MatchBrowserIdc = 9401;
FLO_MatchBrowserReady = false;
FLO_MatchClientMarkers = createHashMap;
FLO_MatchObjectiveSectorMarkerId = "FLO_match_objective_sector";
FLO_MatchLastSectorMarkerRejectKey = "";
FLO_MatchOperationSectorBuffer = 900;
FLO_MatchOperationSectorMinRadius = 1600;
FLO_MatchOperationSectorMaxRadius = 3400;

[
    "FLO_MatchSetupDuration",
    "TIME",
    ["Setup Phase Duration", "Phase 0 setup time before frontline selection begins."],
    ["FOOF", "Match Flow"],
    [0, 3600, 600],
    1,
    { ["setup", _this] call FLO_fnc_matchApplyDurationSetting; },
    false
] call CBA_fnc_addSetting;

[
    "FLO_MatchFrontlineDuration",
    "TIME",
    ["Frontline Selection Duration", "Phase 1 time used to establish the first contact line before the operation begins."],
    ["FOOF", "Match Flow"],
    [0, 3600, 600],
    1,
    { ["frontline", _this] call FLO_fnc_matchApplyDurationSetting; },
    false
] call CBA_fnc_addSetting;

[
    "FLO_MatchOperationDuration",
    "TIME",
    ["Operation Duration", "Phase 2 campaign-day operation length before the server scores and starts the next day."],
    ["FOOF", "Match Flow"],
    [600, 86400, 3600],
    1,
    { ["operation", _this] call FLO_fnc_matchApplyDurationSetting; },
    false
] call CBA_fnc_addSetting;

[
    "FLO_MatchOperationSectorBuffer",
    "SLIDER",
    ["Operation Sector Buffer", "Extra radius added around the generated operation sector after nearby cells and contact edges are included."],
    ["FOOF", "Operation Sector"],
    [0, 3000, 900, 0],
    1,
    { [] call FLO_fnc_matchRebuildOperationSector; },
    false
] call CBA_fnc_addSetting;

[
    "FLO_MatchOperationSectorMinRadius",
    "SLIDER",
    ["Minimum Operation Sector Radius", "Smallest allowed radius for the bright operation sector map ring."],
    ["FOOF", "Operation Sector"],
    [500, 6000, 1600, 0],
    1,
    { [] call FLO_fnc_matchRebuildOperationSector; },
    false
] call CBA_fnc_addSetting;

[
    "FLO_MatchOperationSectorMaxRadius",
    "SLIDER",
    ["Maximum Operation Sector Radius", "Largest allowed radius for the bright operation sector map ring."],
    ["FOOF", "Operation Sector"],
    [1000, 8000, 3400, 0],
    1,
    { [] call FLO_fnc_matchRebuildOperationSector; },
    false
] call CBA_fnc_addSetting;

[
    "FLO_MatchObjectiveScore",
    "SLIDER",
    ["Objective Held Score", "Score awarded to the side that owns the operation objective when the operation ends."],
    ["FOOF", "Operation Scoring"],
    [0, 500, 60, 0],
    1
] call CBA_fnc_addSetting;

[
    "FLO_MatchCaptureSwingScore",
    "SLIDER",
    ["Capture Swing Score", "Bonus score awarded when the operation objective changes owner during the operation."],
    ["FOOF", "Operation Scoring"],
    [0, 500, 30, 0],
    1
] call CBA_fnc_addSetting;

[
    "FLO_MatchSecondaryObjectiveScore",
    "SLIDER",
    ["Secondary AO Held Score", "Score awarded for each secondary AO inside the operation sector owned at operation end."],
    ["FOOF", "Operation Scoring"],
    [0, 250, 25, 0],
    1
] call CBA_fnc_addSetting;

[
    "FLO_MatchSecondaryCaptureSwingScore",
    "SLIDER",
    ["Secondary AO Capture Swing Score", "Bonus score awarded when a secondary AO inside the operation sector changes owner during the operation."],
    ["FOOF", "Operation Scoring"],
    [0, 250, 12, 0],
    1
] call CBA_fnc_addSetting;

[
    "FLO_MatchSectorPresenceScorePerPlayerMinute",
    "SLIDER",
    ["Sector Presence Score", "Passive score per alive player-minute inside the operation sector during Phase 2."],
    ["FOOF", "Operation Scoring"],
    [0, 10, 1, 1],
    1
] call CBA_fnc_addSetting;

[
    "FLO_MatchCellGainScore",
    "SLIDER",
    ["Cell Gain Score", "Score per net territory cell gained during the operation."],
    ["FOOF", "Operation Scoring"],
    [0, 50, 2, 0],
    1
] call CBA_fnc_addSetting;

[
    "FLO_MatchTicketDrainScore",
    "SLIDER",
    ["Ticket Drain Score", "Score per enemy ticket drained during the operation."],
    ["FOOF", "Operation Scoring"],
    [0, 20, 2, 1],
    1
] call CBA_fnc_addSetting;

[
    "FLO_MatchWinnerTicketReward",
    "SLIDER",
    ["Winner Ticket Reward", "Respawn tickets awarded to the side that wins an operation day."],
    ["FOOF", "Operation Rewards"],
    [0, 100, 5, 0],
    1
] call CBA_fnc_addSetting;

[
    "FLO_MatchWinnerFreeUpgradeReward",
    "SLIDER",
    ["Winner Free AO Upgrades", "Free AO upgrade credits awarded to the side that wins an operation day."],
    ["FOOF", "Operation Rewards"],
    [0, 10, 1, 0],
    1
] call CBA_fnc_addSetting;
