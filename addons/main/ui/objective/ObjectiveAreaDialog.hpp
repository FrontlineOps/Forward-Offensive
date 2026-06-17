#define FLO_OBJECTIVE_AREA_CT_WEBBROWSER 106

class FLO_ObjectiveAreaDialog {
    idd = 9500;
    movingEnable = 0;
    enableSimulation = 1;
    onUnload = "uiNamespace setVariable ['FLO_ObjectiveAreaControl', controlNull]; FLO_ObjectiveAreaBrowserReady = false";

    class Controls {
        class Browser: RscText {
            idc = 9501;
            type = FLO_OBJECTIVE_AREA_CT_WEBBROWSER;
            style = 0;
            x = "safeZoneX + (safeZoneW * 0.61)";
            y = "safeZoneY + (safeZoneH * 0.18)";
            w = "safeZoneW * 0.33";
            h = "safeZoneH * 0.34";
            colorBackground[] = {0, 0, 0, 0};
        };
    };
};
