class RscTitles {
    class FLO_NotificationTitle {
        idd = -1;
        movingEnable = 0;
        enableSimulation = 1;
        duration = 1000000000;
        fadeIn = 0;
        fadeOut = 0;
        name = "FLO_NotificationTitle";
        onLoad = "uiNamespace setVariable ['FLO_NotificationDisplay', _this select 0]";
        onUnload = "uiNamespace setVariable ['FLO_NotificationDisplay', displayNull]";

        class Controls {};
    };

    class FLO_AnnouncementTitle {
        idd = -1;
        movingEnable = 0;
        enableSimulation = 1;
        duration = 1000000000;
        fadeIn = 0;
        fadeOut = 0;
        name = "FLO_AnnouncementTitle";
        onLoad = "uiNamespace setVariable ['FLO_AnnouncementDisplay', _this select 0]";
        onUnload = "uiNamespace setVariable ['FLO_AnnouncementDisplay', displayNull]";

        class Controls {};
    };
};
