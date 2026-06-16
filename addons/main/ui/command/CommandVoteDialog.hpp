#define FLO_COMMAND_CT_WEBBROWSER 106

class FLO_CommandVoteDialog {
    idd = 9700;
    movingEnable = 0;
    enableSimulation = 1;
    onUnload = "uiNamespace setVariable ['FLO_CommandVoteControl', controlNull]; FLO_CommandVoteBrowserReady = false; FLO_CommandVoteRenderKey = ''";

    class Controls {
        class Browser: RscText {
            idc = 9701;
            type = FLO_COMMAND_CT_WEBBROWSER;
            style = 0;
            x = "safeZoneX";
            y = "safeZoneY";
            w = "safeZoneW";
            h = "safeZoneH";
            colorBackground[] = {0, 0, 0, 0};
        };
    };
};
