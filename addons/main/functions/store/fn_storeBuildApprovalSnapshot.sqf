params ["_access"];

private _sideKey = _access get "sideKey";
private _player = _access get "player";

createHashMapFromArray [
    ["success", true],
    ["message", ""],
    ["sideKey", _sideKey],
    ["sideName", _access get "sideName"],
    ["factionName", _access get "factionName"],
    ["balance", FLO_ResourceBalances get _sideKey],
    ["personalBalance", [_sideKey, getPlayerUID _player] call FLO_fnc_resourcePersonalBalance],
    ["pendingApprovals", [_access] call FLO_fnc_storePendingApprovalsForAccess]
]
