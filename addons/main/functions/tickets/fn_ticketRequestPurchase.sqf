params ["_player", ["_packId", "", [""]]];

if (!isServer) exitWith {};
if (isNull _player) exitWith {};

private _owner = owner _player;
private _requestOwner = remoteExecutedOwner;

if (_requestOwner <= 2) then {
    _requestOwner = _owner;
};

if ((_requestOwner > 2) && {_owner isNotEqualTo _requestOwner}) exitWith {
    diag_log format [
        "[FLO][Tickets] Rejected ticket purchase request from owner %1 for owner %2",
        _requestOwner,
        _owner
    ];
};

private _send = {
    params ["_success", "_message"];
    [_success, _message, "Tickets"] remoteExecCall ["FLO_fnc_fobReceiveDeployResult", _owner];
};

private _side = side group _player;

if !(_side in [west, east]) exitWith {
    [false, "Reinforcement tickets are only available to BLUFOR and OPFOR."] call _send;
};

private _sideKey = [_side] call FLO_fnc_resourceSideKey;
private _uid = getPlayerUID _player;
private _state = FLO_CommandSideState get _sideKey;

if ((_state get "commanderUid") isNotEqualTo _uid) exitWith {
    [false, "Only the elected commander can buy reinforcement tickets."] call _send;
};

private _packIndex = FLO_TicketPurchasePacks findIf { (_x select 0) isEqualTo _packId };

if (_packIndex < 0) exitWith {
    [false, "Unknown reinforcement ticket pack."] call _send;
};

private _pack = FLO_TicketPurchasePacks select _packIndex;
_pack params ["_selectedPackId", "_name", "_ticketCount", "_price"];

if !([_side, _price, format ["Ticket purchase %1", _name]] call FLO_fnc_resourceSpend) exitWith {
    [false, format ["Not enough faction currency. %1 costs $%2.", _name, _price]] call _send;
};

[_side, _ticketCount, format ["commander purchase %1", _uid]] call FLO_fnc_ticketAdd;
[_owner] call FLO_fnc_resourceSendSnapshot;
[_owner] call FLO_fnc_ticketSendSnapshot;

[true, format ["Purchased %1 for $%2.", _name, _price]] call _send;

diag_log format [
    "[FLO][Tickets] %1 commander=%2 bought %3 tickets price=%4 balance=%5",
    _sideKey,
    name _player,
    _ticketCount,
    _price,
    FLO_TicketBalances get _sideKey
];
