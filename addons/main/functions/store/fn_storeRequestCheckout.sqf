params ["_player", "_fobNetId", "_cart"];

if (!isServer) exitWith {};

private _access = [_player, _fobNetId] call FLO_fnc_storeValidateAccess;
private _owner = _access get "owner";

if !(_access get "success") exitWith {
    private _payload = createHashMapFromArray [
        ["success", false],
        ["message", _access get "message"]
    ];

    [_owner, "store::checkout", _payload] call FLO_fnc_storeSendResponse;
};

private _payload = [_access, _cart] call FLO_fnc_storeCheckout;

if (_payload get "success") then {
    private _hydrate = [_access] call FLO_fnc_storeBuildHydratePayload;
    [_owner, "store::hydrate", _hydrate] call FLO_fnc_storeSendResponse;
};

[_owner, "store::checkout", _payload] call FLO_fnc_storeSendResponse;
