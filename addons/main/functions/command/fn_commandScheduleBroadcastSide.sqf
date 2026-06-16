params ["_side"];

if (!isServer) exitWith {};

private _sideKey = [_side] call FLO_fnc_resourceSideKey;

if (_sideKey in FLO_CommandBroadcastPending) exitWith {};

FLO_CommandBroadcastPending set [_sideKey, true];

[
    {
        params ["_side", "_sideKey"];

        FLO_CommandBroadcastPending deleteAt _sideKey;
        [_side] call FLO_fnc_commandBroadcastSide;
    },
    [_side, _sideKey],
    0.35
] call CBA_fnc_waitAndExecute;
