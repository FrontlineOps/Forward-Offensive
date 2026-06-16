#define FLO_INTEL_CT_WEBBROWSER 106

class FLO_IntelDialog {
    idd = 9600;
    movingEnable = 0;
    enableSimulation = 1;
    onUnload = "uiNamespace setVariable ['FLO_IntelControl', controlNull]; FLO_IntelActiveBodyNetId = ''; FLO_IntelBrowserReady = false";

    class Controls {
        class Browser: RscText {
            idc = 9601;
            type = FLO_INTEL_CT_WEBBROWSER;
            style = 0;
            x = "safeZoneX + (safeZoneW * 0.58)";
            y = "safeZoneY + (safeZoneH * 0.23)";
            w = "safeZoneW * 0.36";
            h = "safeZoneH * 0.44";
            colorBackground[] = {0, 0, 0, 0};
        };
    };
};
