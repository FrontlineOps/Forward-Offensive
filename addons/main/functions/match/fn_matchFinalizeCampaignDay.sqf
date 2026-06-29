if (!isServer) exitWith {};

private _result = [] call FLO_fnc_matchScoreCampaignDay;
private _winner = _result get "winner";
private _winnerText = ["Draw", _winner] select (_winner in ["WEST", "EAST"]);
private _nextOffensiveSide = ["BOTH", _winner] select (_winner in ["WEST", "EAST"]);
private _initiativeText = ["Initiative resets to both sides.", format ["%1 has initiative for the next operation.", _nextOffensiveSide]] select (_nextOffensiveSide in ["WEST", "EAST"]);
private _winnerTicketReward = 0;
private _winnerFreeUpgradeReward = 0;
private _rewardText = "";

if (_winner in ["WEST", "EAST"]) then {
    private _winnerSide = [west, east] select (_winner isEqualTo "EAST");
    private _rewardParts = [];

    _winnerTicketReward = (floor FLO_MatchWinnerTicketReward) max 0;
    _winnerFreeUpgradeReward = (floor FLO_MatchWinnerFreeUpgradeReward) max 0;

    if (_winnerTicketReward > 0) then {
        [_winnerSide, _winnerTicketReward, format ["Operation day %1 victory", _result get "day"]] call FLO_fnc_ticketAdd;
        _rewardParts pushBack format ["%1 tickets", _winnerTicketReward];
    };

    if (_winnerFreeUpgradeReward > 0) then {
        [_winnerSide, _winnerFreeUpgradeReward, format ["Operation day %1 victory", _result get "day"]] call FLO_fnc_objectiveAddFreeUpgradeCredits;
        _rewardParts pushBack format ["%1 free AO upgrades", _winnerFreeUpgradeReward];
    };

    if (_rewardParts isNotEqualTo []) then {
        _rewardText = format [" Rewards: %1.", _rewardParts joinString ", "];
    };
};

_result set ["nextOffensiveSide", _nextOffensiveSide];
_result set ["winnerTicketReward", _winnerTicketReward];
_result set ["winnerFreeUpgradeReward", _winnerFreeUpgradeReward];

FLO_MatchDayResults pushBack _result;
FLO_MatchState set ["campaignScoreWest", (FLO_MatchState get "campaignScoreWest") + (_result get "westScore")];
FLO_MatchState set ["campaignScoreEast", (FLO_MatchState get "campaignScoreEast") + (_result get "eastScore")];
FLO_MatchState set ["nextOffensiveSide", _nextOffensiveSide];
FLO_MatchState set ["revision", (FLO_MatchState get "revision") + 1];

[
    createHashMapFromArray [
        ["mode", "announce"],
        ["type", "success"],
        ["title", format ["Campaign Day %1 Complete", _result get "day"]],
        ["message", format [
            "%1 won the day at %2. WEST %3 - EAST %4. %5%6",
            _winnerText,
            _result get "objectiveName",
            _result get "westScore",
            _result get "eastScore",
            _initiativeText,
            _rewardText
        ]],
        ["duration", 10]
    ]
] call FLO_fnc_notificationBroadcast;

diag_log format [
    "[FLO][Match] Campaign day %1 complete winner=%2 nextOffensive=%3 objective=%4 westScore=%5 eastScore=%6 westCellDelta=%7 eastCellDelta=%8 ticketReward=%9 freeUpgradeReward=%10",
    _result get "day",
    _winner,
    _nextOffensiveSide,
    _result get "objectiveName",
    _result get "westScore",
    _result get "eastScore",
    _result get "westCellDelta",
    _result get "eastCellDelta",
    _winnerTicketReward,
    _winnerFreeUpgradeReward
];

FLO_MatchState set ["campaignDay", (FLO_MatchState get "campaignDay") + 1];
[0] call FLO_fnc_matchSendSnapshot;
["matchCampaignDayComplete"] call FLO_fnc_persistenceScheduleSave;

[] call FLO_fnc_matchStartOperation;
