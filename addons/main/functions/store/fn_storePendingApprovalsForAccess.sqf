params ["_access"];

private _sideKey = _access get "sideKey";
private _player = _access get "player";
private _playerUid = getPlayerUID _player;
private _canUseFactionFunds = [_player] call FLO_fnc_commandPlayerIsCommanderOrDeputy;
private _now = diag_tickTime;
private _pending = [];
private _kept = [];

{
    private _createdAt = _x get "createdAt";
    private _expired = (_now - _createdAt) > FLO_StorePendingApprovalTtl;

    if (!_expired) then {
        _kept pushBack _x;

        if (((_x get "sideKey") isEqualTo _sideKey) && {_canUseFactionFunds || {(_x get "playerUid") isEqualTo _playerUid}}) then {
            _pending pushBack createHashMapFromArray [
                ["id", _x get "id"],
                ["playerName", _x get "playerName"],
                ["isOwn", (_x get "playerUid") isEqualTo _playerUid],
                ["total", _x get "total"],
                ["deploymentFundSpent", _x get "deploymentFundSpent"],
                ["personalSpent", _x get "personalSpent"],
                ["factionTotal", _x get "factionTotal"],
                ["gearCount", _x get "gearCount"],
                ["vehicleCount", _x get "vehicleCount"],
                ["createdAgo", floor (_now - _createdAt)]
            ];
        };
    };
} forEach FLO_StorePendingApprovals;

if ((count _kept) isNotEqualTo (count FLO_StorePendingApprovals)) then {
    ["storeApprovalsExpired"] call FLO_fnc_persistenceScheduleSave;
};

FLO_StorePendingApprovals = _kept;

_pending
