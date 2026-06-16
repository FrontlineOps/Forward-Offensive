params ["_player", "_fobNetId"];

if (!isServer) exitWith {};

private _access = [_player, _fobNetId] call FLO_fnc_storeValidateAccess;
private _owner = _access get "owner";

if !(_access get "success") exitWith {
    [_owner, "store::hydrate", _access] call FLO_fnc_storeSendResponse;
};

private _payload = [_access] call FLO_fnc_storeBuildHydratePayload;
[_owner, "store::hydrate", _payload] call FLO_fnc_storeSendResponse;
