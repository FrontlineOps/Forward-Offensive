#define FLO_STORE_APPROVALS_CT_WEBBROWSER 106

class FLO_StoreApprovalsDialog {
    idd = 9820;
    movingEnable = 0;
    enableSimulation = 1;
    onUnload = "uiNamespace setVariable ['FLO_StoreApprovalsControl', controlNull]";

    class Controls {
        class Browser: RscText {
            idc = 9821;
            type = FLO_STORE_APPROVALS_CT_WEBBROWSER;
            style = 0;
            x = "safeZoneX";
            y = "safeZoneY";
            w = "safeZoneW";
            h = "safeZoneH";
            colorBackground[] = {0, 0, 0, 0};
        };
    };
};
