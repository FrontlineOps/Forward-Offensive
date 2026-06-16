params ["_event", "_payload"];

if (!hasInterface) exitWith {};

if (isMultiplayer && {remoteExecutedOwner isNotEqualTo 2}) exitWith {
    diag_log format ["[FLO][Store] Rejected store response from owner %1", remoteExecutedOwner];
};

if ((typeName _payload) isEqualTo "HASHMAP") then {
    if ("pendingVehicles" in _payload) then {
        private _pendingVehicles = _payload get "pendingVehicles";

        if ((typeName _pendingVehicles) isEqualTo "ARRAY") then {
            FLO_StorePendingVehicles = _pendingVehicles;
        };
    };
};

[_event, _payload] call FLO_fnc_storeUpdateDialog;
