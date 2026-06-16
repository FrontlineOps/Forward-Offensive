params ["_payload"];

if (!hasInterface) exitWith {};

if (isMultiplayer && {remoteExecutedOwner isNotEqualTo 2}) exitWith {
    diag_log format ["[FLO][Store] Rejected store placement result from owner %1", remoteExecutedOwner];
};

if ((typeName _payload) isNotEqualTo "HASHMAP") exitWith {};

private _success = _payload get "success";
private _message = _payload get "message";
private _purchaseId = _payload get "id";

if (_success) then {
    FLO_StorePendingVehicles = FLO_StorePendingVehicles select {
        (_x get "id") isNotEqualTo _purchaseId
    };
};

hint _message;

if (_success && {FLO_StorePendingVehicles isNotEqualTo []}) then {
    [{
        private _next = FLO_StorePendingVehicles select 0;
        [_next get "id"] call FLO_fnc_storeStartVehiclePlacement;
    }, [], 0.6] call CBA_fnc_waitAndExecute;
};
