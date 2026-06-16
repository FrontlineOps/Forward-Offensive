params [["_unit", player]];

private _side = side group _unit;

if !(_side in [west, east]) exitWith {
    false
};

private _sideKey = [_side] call FLO_fnc_resourceSideKey;
private _nearFobs = nearestObjects [_unit, FLO_FOBBuildClasses, FLO_FOBBuildRadius];
private _canBuild = false;

{
    if ((_x getVariable ["FLO_FOB_SideKey", ""]) isEqualTo _sideKey) exitWith {
        _canBuild = true;
    };
} forEach _nearFobs;

_canBuild
