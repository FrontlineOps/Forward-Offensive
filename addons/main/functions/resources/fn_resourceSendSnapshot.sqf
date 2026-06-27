params [["_owner", 0]];

FLO_ResourceSnapshot = [] call FLO_fnc_resourceBuildSnapshot;

if (_owner isEqualTo 0) then {
    {
        private _side = side group _x;
        private _payload = [];

        if (_side in [west, east]) then {
            _payload = [FLO_ResourceSnapshot, [_side] call FLO_fnc_resourceSideKey, getPlayerUID _x] call FLO_fnc_resourceScopeSnapshot;
        };

        [_payload] remoteExecCall ["FLO_fnc_resourceReceiveSnapshot", owner _x];
    } forEach allPlayers;
} else {
    private _target = objNull;

    {
        if ((owner _x) isEqualTo _owner) exitWith {
            _target = _x;
        };
    } forEach allPlayers;

    private _payload = [];

    if (!isNull _target) then {
        private _side = side group _target;

        if (_side in [west, east]) then {
            _payload = [FLO_ResourceSnapshot, [_side] call FLO_fnc_resourceSideKey, getPlayerUID _target] call FLO_fnc_resourceScopeSnapshot;
        };
    };

    [_payload] remoteExecCall ["FLO_fnc_resourceReceiveSnapshot", _owner];
};
