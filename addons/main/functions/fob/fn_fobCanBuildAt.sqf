params ["_side", "_posASL"];

private _sideKey = [_side] call FLO_fnc_resourceSideKey;
private _posAGL = ASLToAGL _posASL;
private _canBuild = false;

{
    private _record = FLO_FOBs get _x;

    if ((_record get "sideKey") isEqualTo _sideKey) then {
        private _fob = _record get "object";

        if ((!isNull _fob) && {alive _fob} && {(_fob distance2D _posAGL) <= (_record get "buildRadius")}) exitWith {
            _canBuild = true;
        };
    };
} forEach keys FLO_FOBs;

_canBuild
