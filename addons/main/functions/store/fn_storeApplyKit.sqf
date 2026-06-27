params ["_gearEntries"];

if (!hasInterface) exitWith {};

if (isMultiplayer && {remoteExecutedOwner isNotEqualTo 2}) exitWith {
    diag_log format ["[FLO][Store] Rejected store kit application from owner %1", remoteExecutedOwner];
};

if ((typeName _gearEntries) isNotEqualTo "ARRAY") exitWith {};

private _failedInventoryAdds = [];

{
    private _targetCategory = _x;

    {
        if ((typeName _x) isNotEqualTo "HASHMAP") then { continue };
        if (!(("className" in _x) && {"category" in _x})) then { continue };

        private _className = _x get "className";
        private _category = _x get "category";

        if (_category isNotEqualTo _targetCategory) then { continue };

        private _quantity = 1;
        private _container = "auto";
        private _slot = "";

        if ("quantity" in _x) then {
            _quantity = floor (_x get "quantity");
        };

        if ("container" in _x) then {
            _container = _x get "container";
        };

        if ("slot" in _x) then {
            _slot = _x get "slot";
        };

        if !(_container in FLO_StoreGearContainers) then {
            _container = "auto";
        };

        if (_quantity < 1) then { continue };

        switch (_category) do {
            case "uniforms": {
                removeUniform player;
                player forceAddUniform _className;
                [uniformContainer player] call FLO_fnc_storeClearCargo;
            };
            case "vests": {
                removeVest player;
                player addVest _className;
                [vestContainer player] call FLO_fnc_storeClearCargo;
            };
            case "backpacks": {
                removeBackpack player;
                player addBackpack _className;
                [backpackContainer player] call FLO_fnc_storeClearCargo;
            };
            case "headgear": {
                removeHeadgear player;
                player addHeadgear _className;
            };
            case "facewear": {
                removeGoggles player;
                player addGoggles _className;
            };
            case "primary": {
                if ((primaryWeapon player) isNotEqualTo "") then {
                    player removeWeapon (primaryWeapon player);
                };

                player addWeapon _className;
            };
            case "handgun": {
                if ((handgunWeapon player) isNotEqualTo "") then {
                    player removeWeapon (handgunWeapon player);
                };

                player addWeapon _className;
            };
            case "secondary": {
                if ((secondaryWeapon player) isNotEqualTo "") then {
                    player removeWeapon (secondaryWeapon player);
                };

                player addWeapon _className;
            };
            case "ammo";
            case "mines": {
                for "_i" from 1 to _quantity do {
                    if !([player, _className, _container] call FLO_fnc_storeAddInventoryItem) then {
                        _failedInventoryAdds pushBack _className;
                    };
                };
            };
            default {
                private _itemType = _className call BIS_fnc_itemType;
                private _group = _itemType select 0;
                private _kind = _itemType select 1;

                if (_category isEqualTo "attachments") then {
                    switch (_slot) do {
                        case "primary": {
                            player addPrimaryWeaponItem _className;
                        };
                        case "handgun": {
                            player addHandgunItem _className;
                        };
                        case "secondary": {
                            player addSecondaryWeaponItem _className;
                        };
                        default {
                            for "_i" from 1 to _quantity do {
                                if !([player, _className, _container] call FLO_fnc_storeAddInventoryItem) then {
                                    _failedInventoryAdds pushBack _className;
                                };
                            };
                        };
                    };
                } else {
                    if (_slot isEqualTo "binocular") then {
                        if ((binocular player) isNotEqualTo "") then {
                            player removeWeapon (binocular player);
                        };

                        player addWeapon _className;
                    } else {
                        if ((_slot isEqualTo "assigned") || {_kind in ["GPS", "Map", "Compass", "Watch", "Radio", "NVGoggles", "Terminal"]}) then {
                            player linkItem _className;
                        } else {
                            if ((_group isEqualTo "Weapon") && {_kind in ["Binocular", "LaserDesignator"]}) then {
                                player addWeapon _className;
                            } else {
                                for "_i" from 1 to _quantity do {
                                    if !([player, _className, _container] call FLO_fnc_storeAddInventoryItem) then {
                                        _failedInventoryAdds pushBack _className;
                                    };
                                };
                            };
                        };
                    };
                };
            };
        };
    } forEach _gearEntries;
} forEach ["uniforms", "vests", "backpacks", "headgear", "facewear", "primary", "handgun", "secondary", "attachments", "misc", "ammo", "mines"];

if (_failedInventoryAdds isEqualTo []) then {
    ["Purchased kit applied.", "success", "Store"] call FLO_fnc_notify;
} else {
    [
        format ["Purchased kit applied, but %1 inventory items did not fit.", count _failedInventoryAdds],
        "warning",
        "Store"
    ] call FLO_fnc_notify;
};
