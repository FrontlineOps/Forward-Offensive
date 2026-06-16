#include "Defines.hpp"

class IDS_Logistics_BuildMenuDialog {
    idd = 9500;
    movingEnable = 0;
    enableSimulationGlobal = 1;
    onLoad = "[_this select 0] call IDS_Logistics_fnc_handlePreview;";

    class RscObject
    {
        type = CT_OBJECT;
        scale = 1;
        direction[] = {0,0,1};
        model = "\core\empty\empty.p3d";
        up[] = {0,1,0};
        shadow = 0;
    };

    class Objects {
        class Entity: RscObject {
            idc = 9506;
            type = 82;
            model = "\A3\Structures_F\Mil\Cargo\Cargo_HQ_V1_F.p3d";
            scale = 0.01;
            direction[] = {0, -0.35, -0.65};
            up[] = {0, 0.65, -0.35};
            x = "0.285 * safeZoneW + safeZoneX";
            y = "0.45 * safeZoneH + safeZoneY";
            z = 0.2;
            xBack = "0.285 * safeZoneW + safeZoneX";
            yBack = "0.45 * safeZoneH + safeZoneY";
            zBack = 0.5;
            inBack = 1;
            enableZoom = 0;
            zoomDuration = 0.001;
            shadow = 0;
        };
    };
    
    class ControlsBackground {
        class Background: IGUIBack {
            idc = -1;
            x = "0.1 * safeZoneW + safeZoneX";
            y = "0.15 * safeZoneH + safeZoneY";
            w = "0.8 * safeZoneW";
            h = "0.7 * safeZoneH";
            colorBackground[] = {0.1, 0.1, 0.1, 0.8};
        };
        
        class HeaderBackground: IGUIBack {
            idc = -1;
            x = "0.1 * safeZoneW + safeZoneX";
            y = "0.15 * safeZoneH + safeZoneY";
            w = "0.8 * safeZoneW";
            h = "0.05 * safeZoneH";
            colorText[] = {1,1,1,1};
            colorBackground[] = {0.5,0.1,0.1,1};
            shadow = 1;
            colorShadow[] = {0,0,0,0.5};
        };
        
        // Left side preview section background with distinct color
        class PreviewBackground: IGUIBack {
            idc = -1;
            x = "0.11 * safeZoneW + safeZoneX";
            y = "0.21 * safeZoneH + safeZoneY";
            w = "0.35 * safeZoneW";
            h = "0.62 * safeZoneH";
            colorBackground[] = {0.18, 0.18, 0.2, 0.9};
        };
        
        // Preview frame with subtle blue accent
        class PreviewFrame: RscFrame {
            idc = -1;
            x = "0.12 * safeZoneW + safeZoneX";
            y = "0.22 * safeZoneH + safeZoneY";
            w = "0.33 * safeZoneW";
            h = "0.46 * safeZoneH";
            colorText[] = {0.5, 0.7, 0.9, 1};
        };
        
        // Right side content background with distinct color
        class RightSideBackground: IGUIBack {
            idc = -1;
            x = "0.47 * safeZoneW + safeZoneX";
            y = "0.21 * safeZoneH + safeZoneY";
            w = "0.42 * safeZoneW";
            h = "0.62 * safeZoneH";
            colorBackground[] = {0.2, 0.2, 0.18, 0.9};
        };
        
        // Key info text
        class KeyInfoText: RscStructuredText {
            idc = -1;
            x = "0.4 * safeZoneW + safeZoneX";
            y = "0.225 * safeZoneH + safeZoneY";
            w = "0.08 * safeZoneW";
            h = "0.07 * safeZoneH";
            text = "W/S: Rotate Up/Down<br/>A/D: Rotate Left/Right<br/>+/-: Zoom In/Out";
            colorText[] = {0.9, 0.9, 1, 1};
            size = 0.03;
        };
    };
    
    class Controls {
        class Title: RscText {
            idc = -1;
            text = "Base Building - Select Entity";
            x = "0.1 * safeZoneW + safeZoneX";
            y = "0.15 * safeZoneH + safeZoneY";
            w = "0.8 * safeZoneW";
            h = "0.05 * safeZoneH";
            colorText[] = {1, 1, 1, 1};
            sizeEx = 0.04;
            style = ST_CENTER;
        };
        
        // LEFT SIDE - Preview label and entity info
        class PreviewSectionFrame: RscFrame {
            idc = -1;
            x = "0.11 * safeZoneW + safeZoneX";
            y = "0.21 * safeZoneH + safeZoneY";
            w = "0.35 * safeZoneW";
            h = "0.62 * safeZoneH";
            colorText[] = {0.7, 0.7, 0.7, 1};
        };
        
        class PreviewLabel: RscText {
            idc = -1;
            text = "Preview";
            x = "0.12 * safeZoneW + safeZoneX";
            y = "0.22 * safeZoneH + safeZoneY";
            w = "0.33 * safeZoneW";
            h = "0.03 * safeZoneH";
            colorText[] = {0.9, 0.9, 1, 1};
            sizeEx = 0.035;
            style = ST_CENTER;
        };
        
        class EntityInfoLabel: RscText {
            idc = -1;
            text = "Entity Information";
            x = "0.12 * safeZoneW + safeZoneX";
            y = "0.685 * safeZoneH + safeZoneY";
            w = "0.33 * safeZoneW";
            h = "0.03 * safeZoneH";
            colorText[] = {0.9, 0.9, 1, 1};
            sizeEx = 0.03;
            style = ST_CENTER;
        };
        
        class EntityInfo: RscStructuredText {
            idc = 9504;
            x = "0.12 * safeZoneW + safeZoneX";
            y = "0.715 * safeZoneH + safeZoneY";
            w = "0.33 * safeZoneW";
            h = "0.105 * safeZoneH";
            colorBackground[] = {0.15, 0.15, 0.17, 1};
            size = 0.03;
        };
        
        // RIGHT SIDE with frames for visual distinction
        class RightSideFrame: RscFrame {
            idc = -1;
            x = "0.47 * safeZoneW + safeZoneX";
            y = "0.21 * safeZoneH + safeZoneY";
            w = "0.42 * safeZoneW";
            h = "0.62 * safeZoneH";
            colorText[] = {0.7, 0.7, 0.7, 1};
        };
        
        // Categories section
        class CategorySectionFrame: RscFrame {
            idc = -1;
            x = "0.48 * safeZoneW + safeZoneX";
            y = "0.22 * safeZoneH + safeZoneY";
            w = "0.4 * safeZoneW";
            h = "0.19 * safeZoneH";
            colorText[] = {0.6, 0.8, 0.6, 1};
        };
        
        class CategoryLabel: RscText {
            idc = -1;
            text = "Categories";
            x = "0.48 * safeZoneW + safeZoneX";
            y = "0.22 * safeZoneH + safeZoneY";
            w = "0.4 * safeZoneW";
            h = "0.03 * safeZoneH";
            colorText[] = {0.8, 1, 0.8, 1};
            sizeEx = 0.035;
            style = ST_CENTER;
        };
        
        class CategoryList: RscListBox {
            idc = 9501;
            x = "0.48 * safeZoneW + safeZoneX";
            y = "0.26 * safeZoneH + safeZoneY";
            w = "0.4 * safeZoneW";
            h = "0.15 * safeZoneH";
            colorBackground[] = {0.17, 0.17, 0.15, 1};
            rowHeight = 0.05;
            sizeEx = 0.03;
            onLBSelChanged = "_this call IDS_Logistics_fnc_updateEntityList";
        };
        
        // Search box - keeping original position
        class SearchSectionFrame: RscFrame {
            idc = -1;
            x = "0.48 * safeZoneW + safeZoneX";
            y = "0.42 * safeZoneH + safeZoneY";
            w = "0.4 * safeZoneW";
            h = "0.03 * safeZoneH";
            colorText[] = {0.7, 0.7, 0.8, 1};
        };
        
        class SearchLabel: RscText {
            idc = -1;
            text = "Search:";
            x = "0.48 * safeZoneW + safeZoneX";
            y = "0.42 * safeZoneH + safeZoneY";
            w = "0.1 * safeZoneW";
            h = "0.03 * safeZoneH";
            colorText[] = {1, 1, 1, 1};
            sizeEx = 0.03;
        };
        
        class SearchEdit: RscEdit {
            idc = 9502;
            x = "0.58 * safeZoneW + safeZoneX";
            y = "0.42 * safeZoneH + safeZoneY";
            w = "0.3 * safeZoneW";
            h = "0.03 * safeZoneH";
            colorBackground[] = {0.3, 0.3, 0.3, 1};
            text = "";
            tooltip = "Search entities";
            onKeyUp = "_this call IDS_Logistics_fnc_searchEntities";
        };
        
        // Entities section
        class EntitiesSectionFrame: RscFrame {
            idc = -1;
            x = "0.48 * safeZoneW + safeZoneX";
            y = "0.46 * safeZoneH + safeZoneY";
            w = "0.4 * safeZoneW";
            h = "0.28 * safeZoneH";
            colorText[] = {0.8, 0.6, 0.6, 1};
        };
        
        class EntitiesLabel: RscText {
            idc = -1;
            text = "Entities";
            x = "0.48 * safeZoneW + safeZoneX";
            y = "0.46 * safeZoneH + safeZoneY";
            w = "0.4 * safeZoneW";
            h = "0.03 * safeZoneH";
            colorText[] = {1, 0.8, 0.8, 1};
            sizeEx = 0.035;
            style = ST_CENTER;
        };
        
        class EntitiesList: RscListBox {
            idc = 9503;
            x = "0.48 * safeZoneW + safeZoneX";
            y = "0.5 * safeZoneH + safeZoneY";
            w = "0.4 * safeZoneW";
            h = "0.24 * safeZoneH";
            colorBackground[] = {0.17, 0.15, 0.15, 1};
            rowHeight = 0.05;
            sizeEx = 0.03;
            onLBSelChanged = "_this call IDS_Logistics_fnc_updatePreview";
        };
        
        // Buttons section with a distinct background
        class ButtonsBackground: IGUIBack {
            idc = -1;
            x = "0.47 * safeZoneW + safeZoneX";
            y = "0.75 * safeZoneH + safeZoneY";
            w = "0.42 * safeZoneW";
            h = "0.08 * safeZoneH";
            colorBackground[] = {0.22, 0.22, 0.22, 1};
        };
        
        class ButtonsFrame: RscFrame {
            idc = -1;
            x = "0.47 * safeZoneW + safeZoneX";
            y = "0.75 * safeZoneH + safeZoneY";
            w = "0.42 * safeZoneW";
            h = "0.08 * safeZoneH";
            colorText[] = {0.7, 0.7, 0.7, 1};
        };
        
        class SelectButton: RscButton {
            idc = 9505;
            text = "Select";
            x = "0.48 * safeZoneW + safeZoneX";
            y = "0.765 * safeZoneH + safeZoneY";
            w = "0.19 * safeZoneW";
            h = "0.05 * safeZoneH";
            colorBackground[] = {0.2, 0.6, 0.2, 1};
            colorBackgroundActive[] = {0.2, 0.8, 0.2, 1};
            action = "call IDS_Logistics_fnc_selectEntity";
            sizeEx = 0.04;
        };
        
        class CancelButton: RscButton {
            idc = -1;
            text = "Cancel";
            x = "0.68 * safeZoneW + safeZoneX";
            y = "0.765 * safeZoneH + safeZoneY";
            w = "0.2 * safeZoneW";
            h = "0.05 * safeZoneH";
            colorBackground[] = {0.6, 0.2, 0.2, 1};
            colorBackgroundActive[] = {0.8, 0.2, 0.2, 1};
            action = "closeDialog 0";
            sizeEx = 0.04;
        };
    };
};
