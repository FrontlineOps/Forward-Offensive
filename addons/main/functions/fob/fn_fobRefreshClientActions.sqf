if (!hasInterface) exitWith {};
if (isNull player) exitWith {};

{
    private _className = _x;

    {
        if (
            alive _x
            && {(_x getVariable ["FLO_FOB_Id", ""]) isNotEqualTo ""}
            && {(_x getVariable ["FLO_FOB_SideKey", ""]) isNotEqualTo ""}
        ) then {
            [_x] call FLO_fnc_fobAddClientAction;
        };
    } forEach allMissionObjects _className;
} forEach FLO_FOBBuildClasses;
