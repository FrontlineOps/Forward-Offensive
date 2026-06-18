params ["_unit", "_uid", "_sideKey"];

if (!isServer) exitWith {};
if (isNull _unit) exitWith {};
if (_uid isEqualTo "") exitWith {};

private _unitUid = getPlayerUID _unit;

if ((_unitUid isNotEqualTo "") && {_unitUid isNotEqualTo _uid}) exitWith {
    diag_log format [
        "[FLO][Tickets] Rejected ACE medical death for uid=%1 unitUid=%2 unit=%3",
        _uid,
        _unitUid,
        _unit
    ];
};

if (_sideKey in ["WEST", "EAST"]) then {
    _unit setVariable ["FLO_TicketPlayerUid", _uid, true];
    _unit setVariable ["FLO_TicketSideKey", _sideKey, true];
    FLO_TicketPlayerSides set [_uid, _sideKey];
};

[_unit, objNull, objNull, false] call FLO_fnc_ticketHandleDeath;
