params ["_side", "_amount", ["_reason", ""]];

if (!isServer) exitWith { false };

private _sideKey = [_side] call FLO_fnc_resourceSideKey;
private _amountInt = floor _amount;

if (_amountInt < 0) then {
    throw format ["[FLO][Tickets] Cannot add negative ticket amount: %1", _amountInt];
};

if (_amountInt isEqualTo 0) exitWith { true };

private _oldBalance = FLO_TicketBalances get _sideKey;
private _newBalance = _oldBalance + _amountInt;

FLO_TicketBalances set [_sideKey, _newBalance];
FLO_TicketPurchasedTotal set [_sideKey, (FLO_TicketPurchasedTotal get _sideKey) + _amountInt];
FLO_TicketRevision = FLO_TicketRevision + 1;

if (_oldBalance <= 0) then {
    [_side, false, format ["%1 respawn tickets available.", _newBalance]] call FLO_fnc_ticketBroadcastRespawnLock;
};

["ticketAdd"] call FLO_fnc_persistenceScheduleSave;
[] call FLO_fnc_ticketScheduleSnapshot;

diag_log format [
    "[FLO][Tickets] Added %1 tickets to %2 reason=%3 balance=%4",
    _amountInt,
    _sideKey,
    _reason,
    _newBalance
];

true
