params [["_owner", 0, [0]]];

if (!isServer) exitWith {};

private _snapshotForUnit = {
    params ["_unit"];

    private _payload = createHashMap;
    private _side = side group _unit;

    if (_side in [west, east]) then {
        private _sideKey = [_side] call FLO_fnc_resourceSideKey;

        _payload = createHashMapFromArray [
            ["sideKey", _sideKey],
            ["tickets", FLO_TicketBalances get _sideKey],
            ["purchased", FLO_TicketPurchasedTotal get _sideKey],
            ["consumed", FLO_TicketConsumedTotal get _sideKey],
            ["revision", FLO_TicketRevision]
        ];
    };

    _payload
};

if (_owner isEqualTo 0) exitWith {
    {
        [[_x] call _snapshotForUnit] remoteExecCall ["FLO_fnc_ticketReceiveSnapshot", owner _x];
    } forEach allPlayers;
};

private _target = objNull;

{
    if ((owner _x) isEqualTo _owner) exitWith {
        _target = _x;
    };
} forEach allPlayers;

private _payload = createHashMap;

if (!isNull _target) then {
    _payload = [_target] call _snapshotForUnit;
};

[_payload] remoteExecCall ["FLO_fnc_ticketReceiveSnapshot", _owner];
