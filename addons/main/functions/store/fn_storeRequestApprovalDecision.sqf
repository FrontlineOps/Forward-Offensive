params ["_player", "_approvalId", ["_approved", true]];

if (!isServer) exitWith {};

private _access = [_player] call FLO_fnc_storeValidateApprovalAccess;
private _owner = _access get "owner";

private _sendDecision = {
    params ["_success", "_message", ["_payloadAccess", _access]];

    private _payload = createHashMapFromArray [
        ["success", _success],
        ["message", _message]
    ];

    if (_payloadAccess get "success") then {
        private _snapshot = [_payloadAccess] call FLO_fnc_storeBuildApprovalSnapshot;

        {
            _payload set [_x, _snapshot get _x];
        } forEach ["sideKey", "sideName", "factionName", "balance", "personalBalance", "pendingApprovals"];
    };

    [_owner, "storeApprovals::decision", _payload] call FLO_fnc_storeSendApprovalsResponse;
};

if !(_access get "success") exitWith {
    [false, _access get "message"] call _sendDecision;
};

private _sideKey = _access get "sideKey";
private _index = -1;
private _approval = createHashMap;
private _now = diag_tickTime;

for "_i" from 0 to ((count FLO_StorePendingApprovals) - 1) do {
    private _entry = FLO_StorePendingApprovals select _i;

    if (((_entry get "id") isEqualTo _approvalId) && {(_entry get "sideKey") isEqualTo _sideKey}) exitWith {
        _index = _i;
        _approval = _entry;
    };
};

if (_index < 0) exitWith {
    [false, "That checkout approval is no longer pending."] call _sendDecision;
};

if ((_now - (_approval get "createdAt")) > FLO_StorePendingApprovalTtl) exitWith {
    FLO_StorePendingApprovals deleteAt _index;
    ["storeApprovalExpired"] call FLO_fnc_persistenceScheduleSave;
    [false, "That checkout approval expired."] call _sendDecision;
};

if (!_approved) exitWith {
    FLO_StorePendingApprovals deleteAt _index;
    ["storeApprovalDenied"] call FLO_fnc_persistenceScheduleSave;

    {
        if ((getPlayerUID _x) isEqualTo (_approval get "playerUid")) exitWith {
            [_x, createHashMapFromArray [
                ["mode", "notify"],
                ["type", "warning"],
                ["title", "Store Approval"],
                ["message", format ["%1 denied your Store checkout.", name _player]],
                ["duration", 5]
            ]] call FLO_fnc_notificationSendPlayer;
        };
    } forEach allPlayers;

    [true, "Checkout approval denied."] call _sendDecision;
};

private _buyer = objNull;

{
    if ((getPlayerUID _x) isEqualTo (_approval get "playerUid")) exitWith {
        _buyer = _x;
    };
} forEach allPlayers;

if (isNull _buyer) exitWith {
    [false, "The requesting player is no longer online."] call _sendDecision;
};

private _approvalFobNetId = _approval get "fobNetId";
private _approvalFobId = _approval get "fobId";

if (_approvalFobId in FLO_FOBs) then {
    private _fobRecord = FLO_FOBs get _approvalFobId;
    _approvalFobNetId = netId (_fobRecord get "object");
};

private _buyerAccess = [_buyer, _approvalFobNetId, false] call FLO_fnc_storeValidateAccess;

if !(_buyerAccess get "success") exitWith {
    [false, format ["Cannot approve: %1", _buyerAccess get "message"]] call _sendDecision;
};

private _cart = [];

{
    private _record = createHashMapFromArray _x;

    _cart pushBack createHashMapFromArray [
        ["className", _record get "className"],
        ["entryKind", _record get "entryKind"],
        ["quantity", _record get "quantity"],
        ["container", _record get "container"],
        ["slot", _record get "slot"]
    ];
} forEach (_approval get "cart");

private _checkoutPayload = [_buyerAccess, _cart, true, _player] call FLO_fnc_storeCheckout;

if !(_checkoutPayload get "success") exitWith {
    [false, format ["Cannot approve: %1", _checkoutPayload get "message"]] call _sendDecision;
};

FLO_StorePendingApprovals deleteAt _index;
["storeApprovalApproved"] call FLO_fnc_persistenceScheduleSave;

private _buyerOwner = owner _buyer;
private _buyerHydrate = [_buyerAccess] call FLO_fnc_storeBuildHydratePayload;
[_buyerOwner, "store::hydrate", _buyerHydrate] call FLO_fnc_storeSendResponse;
[_buyerOwner, "store::checkout", _checkoutPayload] call FLO_fnc_storeSendResponse;

[_buyer, createHashMapFromArray [
    ["mode", "notify"],
    ["type", "success"],
    ["title", "Store Approval"],
    ["message", format ["%1 approved your Store checkout.", name _player]],
    ["duration", 5]
]] call FLO_fnc_notificationSendPlayer;

[true, format ["Approved %1's checkout.", _approval get "playerName"]] call _sendDecision;
