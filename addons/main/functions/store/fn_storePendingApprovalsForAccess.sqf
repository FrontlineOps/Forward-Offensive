params ["_access"];

private _sideKey = _access get "sideKey";
private _now = diag_tickTime;
private _pending = [];
private _kept = [];

{
    private _createdAt = _x get "createdAt";
    private _expired = (_now - _createdAt) > FLO_StorePendingApprovalTtl;

    if (!_expired) then {
        _kept pushBack _x;

        if ((_x get "sideKey") isEqualTo _sideKey) then {
            _pending pushBack createHashMapFromArray [
                ["id", _x get "id"],
                ["playerName", _x get "playerName"],
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
