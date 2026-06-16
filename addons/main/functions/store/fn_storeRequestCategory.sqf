params ["_player", "_fobNetId", "_category"];

if (!isServer) exitWith {};

private _access = [_player, _fobNetId] call FLO_fnc_storeValidateAccess;
private _owner = _access get "owner";

if !(_access get "success") exitWith {
    private _payload = createHashMapFromArray [
        ["success", false],
        ["message", _access get "message"],
        ["category", _category],
        ["items", []]
    ];

    [_owner, "store::category", _payload] call FLO_fnc_storeSendResponse;
};

private _payload = [_access, _category] call FLO_fnc_storeBuildCategoryPayload;
[_owner, "store::category", _payload] call FLO_fnc_storeSendResponse;
