params ["_player"];

if (!isServer) exitWith {};

private _access = [_player] call FLO_fnc_storeValidateApprovalAccess;
private _owner = _access get "owner";

if !(_access get "success") exitWith {
    [_owner, "storeApprovals::snapshot", _access] call FLO_fnc_storeSendApprovalsResponse;
};

private _payload = [_access] call FLO_fnc_storeBuildApprovalSnapshot;
[_owner, "storeApprovals::snapshot", _payload] call FLO_fnc_storeSendApprovalsResponse;
