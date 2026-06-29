if (!isServer) exitWith { createHashMap };

private _objectiveId = FLO_MatchState get "operationObjectiveId";
private _objective = FLO_Objectives get _objectiveId;
private _owner = _objective get "owner";
private _ownerKey = [_owner] call FLO_fnc_objectiveSideKey;
private _initialOwner = FLO_MatchState get "operationInitialOwner";
private _westScore = 0;
private _eastScore = 0;
private _westPrimaryObjectiveScore = 0;
private _eastPrimaryObjectiveScore = 0;
private _westPrimaryCaptureScore = 0;
private _eastPrimaryCaptureScore = 0;

if (_owner isEqualTo west) then {
    _westPrimaryObjectiveScore = FLO_MatchObjectiveScore;
    _westScore = _westScore + _westPrimaryObjectiveScore;
};

if (_owner isEqualTo east) then {
    _eastPrimaryObjectiveScore = FLO_MatchObjectiveScore;
    _eastScore = _eastScore + _eastPrimaryObjectiveScore;
};

if ((_ownerKey isNotEqualTo "NONE") && {_ownerKey isNotEqualTo _initialOwner}) then {
    if (_owner isEqualTo west) then {
        _westPrimaryCaptureScore = FLO_MatchCaptureSwingScore;
        _westScore = _westScore + _westPrimaryCaptureScore;
    };

    if (_owner isEqualTo east) then {
        _eastPrimaryCaptureScore = FLO_MatchCaptureSwingScore;
        _eastScore = _eastScore + _eastPrimaryCaptureScore;
    };
};

private _secondaryObjectiveIds = FLO_MatchState get "operationSecondaryObjectiveIds";
private _initialSecondaryOwners = createHashMapFromArray (FLO_MatchState get "operationInitialSecondaryOwners");
private _westSecondaryHeld = 0;
private _eastSecondaryHeld = 0;
private _westSecondaryObjectiveScore = 0;
private _eastSecondaryObjectiveScore = 0;
private _westSecondaryCaptureScore = 0;
private _eastSecondaryCaptureScore = 0;

{
    private _secondaryObjective = FLO_Objectives get _x;
    private _secondaryOwner = _secondaryObjective get "owner";
    private _secondaryOwnerKey = [_secondaryOwner] call FLO_fnc_objectiveSideKey;
    private _secondaryInitialOwner = _initialSecondaryOwners get _x;

    if (_secondaryOwner isEqualTo west) then {
        _westSecondaryHeld = _westSecondaryHeld + 1;
        _westSecondaryObjectiveScore = _westSecondaryObjectiveScore + FLO_MatchSecondaryObjectiveScore;
    };

    if (_secondaryOwner isEqualTo east) then {
        _eastSecondaryHeld = _eastSecondaryHeld + 1;
        _eastSecondaryObjectiveScore = _eastSecondaryObjectiveScore + FLO_MatchSecondaryObjectiveScore;
    };

    if ((_secondaryOwnerKey isNotEqualTo "NONE") && {_secondaryOwnerKey isNotEqualTo _secondaryInitialOwner}) then {
        if (_secondaryOwner isEqualTo west) then {
            _westSecondaryCaptureScore = _westSecondaryCaptureScore + FLO_MatchSecondaryCaptureSwingScore;
        };

        if (_secondaryOwner isEqualTo east) then {
            _eastSecondaryCaptureScore = _eastSecondaryCaptureScore + FLO_MatchSecondaryCaptureSwingScore;
        };
    };
} forEach _secondaryObjectiveIds;

_westScore = _westScore + _westSecondaryObjectiveScore + _westSecondaryCaptureScore;
_eastScore = _eastScore + _eastSecondaryObjectiveScore + _eastSecondaryCaptureScore;

private _westCellsNow = [west] call FLO_fnc_matchSideOwnedCellCount;
private _eastCellsNow = [east] call FLO_fnc_matchSideOwnedCellCount;
private _westCellDelta = _westCellsNow - (FLO_MatchState get "operationInitialWestCells");
private _eastCellDelta = _eastCellsNow - (FLO_MatchState get "operationInitialEastCells");
private _westCellGainScore = (_westCellDelta max 0) * FLO_MatchCellGainScore;
private _eastCellGainScore = (_eastCellDelta max 0) * FLO_MatchCellGainScore;

_westScore = _westScore + _westCellGainScore;
_eastScore = _eastScore + _eastCellGainScore;

private _westTicketsDrained = ((FLO_MatchState get "operationInitialWestTickets") - (FLO_TicketBalances get "WEST")) max 0;
private _eastTicketsDrained = ((FLO_MatchState get "operationInitialEastTickets") - (FLO_TicketBalances get "EAST")) max 0;
private _westTicketDrainScore = _eastTicketsDrained * FLO_MatchTicketDrainScore;
private _eastTicketDrainScore = _westTicketsDrained * FLO_MatchTicketDrainScore;

_westScore = _westScore + _westTicketDrainScore;
_eastScore = _eastScore + _eastTicketDrainScore;

private _westSectorPresenceScore = round (FLO_MatchState get "operationWestSectorPresenceScore");
private _eastSectorPresenceScore = round (FLO_MatchState get "operationEastSectorPresenceScore");

_westScore = _westScore + _westSectorPresenceScore;
_eastScore = _eastScore + _eastSectorPresenceScore;

private _winner = "DRAW";

if (_westScore > _eastScore) then {
    _winner = "WEST";
};

if (_eastScore > _westScore) then {
    _winner = "EAST";
};

createHashMapFromArray [
    ["day", FLO_MatchState get "campaignDay"],
    ["operationId", FLO_MatchState get "operationId"],
    ["objectiveId", _objectiveId],
    ["objectiveName", _objective get "name"],
    ["objectiveOwner", _ownerKey],
    ["initialOwner", _initialOwner],
    ["sectorObjectiveIds", FLO_MatchState get "operationSectorObjectiveIds"],
    ["secondaryObjectiveIds", _secondaryObjectiveIds],
    ["secondaryObjectiveCount", count _secondaryObjectiveIds],
    ["winner", _winner],
    ["westScore", _westScore],
    ["eastScore", _eastScore],
    ["westPrimaryObjectiveScore", _westPrimaryObjectiveScore],
    ["eastPrimaryObjectiveScore", _eastPrimaryObjectiveScore],
    ["westPrimaryCaptureScore", _westPrimaryCaptureScore],
    ["eastPrimaryCaptureScore", _eastPrimaryCaptureScore],
    ["westSecondaryHeld", _westSecondaryHeld],
    ["eastSecondaryHeld", _eastSecondaryHeld],
    ["westSecondaryObjectiveScore", _westSecondaryObjectiveScore],
    ["eastSecondaryObjectiveScore", _eastSecondaryObjectiveScore],
    ["westSecondaryCaptureScore", _westSecondaryCaptureScore],
    ["eastSecondaryCaptureScore", _eastSecondaryCaptureScore],
    ["westCellDelta", _westCellDelta],
    ["eastCellDelta", _eastCellDelta],
    ["westCellGainScore", _westCellGainScore],
    ["eastCellGainScore", _eastCellGainScore],
    ["westTicketsDrained", _westTicketsDrained],
    ["eastTicketsDrained", _eastTicketsDrained],
    ["westTicketDrainScore", _westTicketDrainScore],
    ["eastTicketDrainScore", _eastTicketDrainScore],
    ["westSectorPresenceScore", _westSectorPresenceScore],
    ["eastSectorPresenceScore", _eastSectorPresenceScore],
    ["westSectorPresenceTicks", FLO_MatchState get "operationWestSectorPresenceTicks"],
    ["eastSectorPresenceTicks", FLO_MatchState get "operationEastSectorPresenceTicks"],
    ["endedAt", systemTimeUTC]
]
