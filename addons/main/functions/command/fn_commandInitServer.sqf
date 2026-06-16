if (!isServer) exitWith {};

FLO_CommandRevision = 0;
FLO_CommandSideState = createHashMap;
FLO_CommandFactionOptions = createHashMapFromArray [
    ["WEST", [west] call FLO_fnc_commandBuildFactionOptions],
    ["EAST", [east] call FLO_fnc_commandBuildFactionOptions]
];

{
    private _sideKey = _x;

    FLO_CommandSideState set [
        _sideKey,
        createHashMapFromArray [
            ["initialVoteStarted", false],
            ["commanderVoteOpen", false],
            ["commanderVoteReason", ""],
            ["commanderVoteEndsAt", 0],
            ["commanderVotePromptId", ""],
            ["commanderUid", ""],
            ["commanderName", ""],
            ["commanderVotes", createHashMap],
            ["factionVoteOpen", false],
            ["factionVoteReason", ""],
            ["factionVoteEndsAt", 0],
            ["factionVotePromptId", ""],
            ["factionClass", ""],
            ["factionName", ""],
            ["factionVotes", createHashMap],
            ["permissionGrants", createHashMapFromArray [
                ["build", []],
                ["fob", []],
                ["garage", []],
                ["logistics", []],
                ["store", []]
            ]]
        ]
    ];
} forEach ["WEST", "EAST"];

FLO_CommandPlayerDisconnectedEh = addMissionEventHandler [
    "PlayerDisconnected",
    {
        params ["_id", "_uid", "_name"];

        {
            private _sideKey = _x;
            private _state = FLO_CommandSideState get _sideKey;

            if ((_state get "commanderUid") isEqualTo _uid) then {
                _state set ["commanderUid", ""];
                _state set ["commanderName", ""];

                private _side = [west, east] select (_sideKey isEqualTo "EAST");
                [_sideKey, "commander", "commanderDisconnected", FLO_CommandReplacementVoteDuration] call FLO_fnc_commandStartVoteWindow;
                [_side] call FLO_fnc_commandScheduleBroadcastSide;
                ["commanderDisconnected"] call FLO_fnc_persistenceScheduleSave;

                diag_log format [
                    "[FLO][Command] %1 commander %2 disconnected; replacement commander vote opened",
                    _sideKey,
                    _name
                ];
            };
        } forEach ["WEST", "EAST"];
    }
];

diag_log format [
    "[FLO][Command] Command voting initialized westFactions=%1 eastFactions=%2",
    count (FLO_CommandFactionOptions get "WEST"),
    count (FLO_CommandFactionOptions get "EAST")
];
