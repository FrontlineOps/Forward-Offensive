#define CT_STATIC 0
#define CT_BUTTON 1
#define CT_EDIT 2
#define CT_LISTBOX 5
#define CT_STRUCTURED_TEXT 13
#define CT_OBJECT 80
#define ST_LEFT 0
#define ST_CENTER 2

class RscText {
    access = 0;
    type = CT_STATIC;
    idc = -1;
    style = ST_LEFT;
    linespacing = 1;
    colorBackground[] = {0, 0, 0, 0};
    colorText[] = {1, 1, 1, 1};
    text = "";
    shadow = 1;
    font = "PuristaMedium";
    sizeEx = 0.04;
    fixedWidth = 0;
    x = 0;
    y = 0;
    h = 0.037;
    w = 0.3;
};

class RscButton {
    access = 0;
    type = CT_BUTTON;
    text = "";
    colorText[] = {1, 1, 1, 1};
    colorDisabled[] = {0.4, 0.4, 0.4, 1};
    colorBackground[] = {0.2, 0.2, 0.2, 1};
    colorBackgroundDisabled[] = {0.2, 0.2, 0.2, 0.5};
    colorBackgroundActive[] = {0.3, 0.3, 0.3, 1};
    colorFocused[] = {0.3, 0.3, 0.3, 1};
    colorShadow[] = {0, 0, 0, 0};
    colorBorder[] = {0, 0, 0, 0};
    soundEnter[] = {"", 0.09, 1};
    soundPush[] = {"", 0.09, 1};
    soundClick[] = {"", 0.09, 1};
    soundEscape[] = {"", 0.09, 1};
    style = ST_CENTER;
    x = 0;
    y = 0;
    w = 0.095589;
    h = 0.039216;
    shadow = 2;
    font = "PuristaMedium";
    sizeEx = 0.03921;
    offsetX = 0;
    offsetY = 0;
    offsetPressedX = 0;
    offsetPressedY = 0;
    borderSize = 0;
};

class RscListBox {
    access = 0;
    type = CT_LISTBOX;
    style = ST_LEFT;
    rowHeight = 0.03;
    colorText[] = {1, 1, 1, 1};
    colorDisabled[] = {1, 1, 1, 0.25};
    colorScrollbar[] = {1, 0, 0, 0};
    colorSelect[] = {0, 0, 0, 1};
    colorSelect2[] = {0, 0, 0, 1};
    colorSelectBackground[] = {0.95, 0.95, 0.95, 1};
    colorSelectBackground2[] = {1, 1, 1, 0.5};
    colorBackground[] = {0, 0, 0, 0.3};
    soundSelect[] = {"", 0.1, 1};
    font = "PuristaMedium";
    sizeEx = 0.035;
    shadow = 0;
    class ListScrollBar {
        color[] = {1, 1, 1, 1};
        autoScrollEnabled = 1;
    };
};

class RscEdit {
    access = 0;
    type = CT_EDIT;
    style = ST_LEFT;
    x = 0;
    y = 0;
    h = 0.04;
    w = 0.2;
    colorBackground[] = {0, 0, 0, 0.5};
    colorText[] = {1, 1, 1, 1};
    colorSelection[] = {1, 1, 1, 0.25};
    autocomplete = "";
    text = "";
    size = 0.2;
    font = "PuristaMedium";
    shadow = 2;
    sizeEx = 0.035;
};

class RscFrame {
    type = CT_STATIC;
    idc = -1;
    style = 64;
    shadow = 2;
    colorBackground[] = {0, 0, 0, 0};
    colorText[] = {1, 1, 1, 1};
    font = "PuristaMedium";
    sizeEx = 0.02;
    text = "";
};

class RscStructuredText {
    access = 0;
    type = CT_STRUCTURED_TEXT;
    idc = -1;
    style = ST_LEFT;
    colorText[] = {1, 1, 1, 1};
    colorBackground[] = {0, 0, 0, 0};
    class Attributes {
        font = "PuristaMedium";
        color = "#ffffff";
        align = "left";
        shadow = 1;
    };
    text = "";
    size = 0.035;
    shadow = 1;
    x = 0;
    y = 0;
    h = 0.035;
    w = 0.1;
};

class IGUIBack {
    type = CT_STATIC;
    idc = -1;
    style = 128;
    text = "";
    colorText[] = {0, 0, 0, 0};
    font = "PuristaMedium";
    sizeEx = 0;
    shadow = 0;
    x = 0.1;
    y = 0.1;
    w = 0.1;
    h = 0.1;
    colorBackground[] = {0, 0, 0, 0.7};
};
