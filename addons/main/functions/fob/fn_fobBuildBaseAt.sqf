params ["_side", "_posASL"];

private _sideKey = [_side] call FLO_fnc_resourceSideKey;
private _posAGL = ASLToAGL _posASL;
private _base = createHashMap;

{
    private _record = FLO_FOBs get _x;

    if ((_record get "sideKey") isEqualTo _sideKey) then {
        private _object = _record get "object";

        if ((!isNull _object) && {alive _object} && {(_object distance2D _posAGL) <= (_record get "buildRadius")}) exitWith {
            _base = _record;
        };
    };
} forEach keys FLO_FOBs;

_base
