params ["_side", ["_amount", FLO_TicketRespawnCost, [0]], ["_reason", ""]];

if (!isServer) exitWith { false };

private _sideKey = [_side] call FLO_fnc_resourceSideKey;
private _amountInt = floor _amount;

if (_amountInt < 0) then {
    throw format ["[FLO][Tickets] Cannot consume negative ticket amount: %1", _amountInt];
};

private _balance = FLO_TicketBalances get _sideKey;

if (_balance < _amountInt) exitWith { false };

private _newBalance = _balance - _amountInt;

FLO_TicketBalances set [_sideKey, _newBalance];
FLO_TicketConsumedTotal set [_sideKey, (FLO_TicketConsumedTotal get _sideKey) + _amountInt];
FLO_TicketRevision = FLO_TicketRevision + 1;

if (_newBalance <= 0) then {
    [_side, true, "No respawn tickets remain. Hold until command buys reinforcements."] call FLO_fnc_ticketBroadcastRespawnLock;
};

["ticketConsume"] call FLO_fnc_persistenceScheduleSave;
[] call FLO_fnc_ticketScheduleSnapshot;

diag_log format [
    "[FLO][Tickets] Consumed %1 tickets from %2 reason=%3 balance=%4",
    _amountInt,
    _sideKey,
    _reason,
    _newBalance
];

true
