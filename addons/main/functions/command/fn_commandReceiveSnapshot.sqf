params ["_snapshot"];

if (!hasInterface) exitWith {};

if (isMultiplayer && {remoteExecutedOwner isNotEqualTo 2} && {remoteExecutedOwner isNotEqualTo 0}) exitWith {
    diag_log format ["[FLO][Command] Rejected command snapshot from owner %1", remoteExecutedOwner];
};

FLO_CommandSnapshot = _snapshot;

if (_snapshot get "shouldPromptVote") then {
    private _promptId = _snapshot get "votePromptId";
    private _display = findDisplay FLO_CommandVoteDialogIdd;
    private _isNewPrompt = FLO_CommandLastVotePromptId isNotEqualTo _promptId;
    FLO_CommandVoteCloseRevision = -1;
    FLO_CommandVoteAutoClosePromptId = _promptId;

    if (_isNewPrompt) then {
        FLO_CommandLastVotePromptId = _promptId;
        FLO_CommandVoteDismissedPromptId = "";
        FLO_CommandVoteRenderKey = "";

        if ((_snapshot get "commanderVoteReason") isEqualTo "commanderDisconnected") then {
            [
                "Commander Replacement Vote",
                format [
                    "%1 commander left. Vote for a replacement in the next 2 minutes.",
                    _snapshot get "sideName"
                ],
                "announcement",
                7
            ] call FLO_fnc_announce;
        };
    };

    if ((isNull _display) && {FLO_CommandVoteDismissedPromptId isNotEqualTo _promptId}) then {
        if ([] call FLO_fnc_commandCanOpenVoteDialog) then {
            [] call FLO_fnc_commandOpenVoteDialog;
        } else {
            if (!FLO_CommandVoteOpenWhenReady) then {
                FLO_CommandVoteOpenWhenReady = true;

                [
                    { [] call FLO_fnc_commandCanOpenVoteDialog },
                    {
                        FLO_CommandVoteOpenWhenReady = false;

                        if (("shouldPromptVote" in FLO_CommandSnapshot) && {FLO_CommandSnapshot get "shouldPromptVote"}) then {
                            private _promptId = FLO_CommandSnapshot get "votePromptId";

                            if (FLO_CommandVoteDismissedPromptId isNotEqualTo _promptId) then {
                                [] call FLO_fnc_commandOpenVoteDialog;
                            };
                        };
                    },
                    []
                ] call CBA_fnc_waitUntilAndExecute;
            };
        };
    };
} else {
    private _display = findDisplay FLO_CommandVoteDialogIdd;
    private _autoClosePromptId = FLO_CommandVoteAutoClosePromptId;

    FLO_CommandVoteAutoClosePromptId = "";

    if ((!isNull _display) && {_autoClosePromptId isNotEqualTo ""}) then {
        private _revision = _snapshot get "revision";

        if (FLO_CommandVoteCloseRevision isNotEqualTo _revision) then {
            FLO_CommandVoteCloseRevision = _revision;

            _display closeDisplay 0;
            uiNamespace setVariable ["FLO_CommandVoteControl", controlNull];
        };
    };
};

[] call FLO_fnc_commandUpdateVoteDialog;
[] call FLO_fnc_fobRefreshClientActions;

if (!isNull (uiNamespace getVariable ["FLO_DeployControl", controlNull])) then {
    FLO_FOBDeployRenderKey = "";
    [] call FLO_fnc_fobUpdateDeployDialog;
};
