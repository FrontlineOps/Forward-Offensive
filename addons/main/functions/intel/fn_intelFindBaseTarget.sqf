params ["_requestSideKey", "_enemySideKey"];

private _candidates = [];

{
    private _record = FLO_FOBs get _x;

    if ((_record get "sideKey") isEqualTo _enemySideKey) then {
        private _base = _record get "object";

        if ((!isNull _base) && {alive _base}) then {
            _candidates pushBack _record;
        };
    };
} forEach keys FLO_FOBs;

if (_candidates isEqualTo []) exitWith { createHashMap };

private _target = selectRandom _candidates;
private _foundCount = FLO_IntelBaseFinds get _requestSideKey;
private _radius = (FLO_IntelBaseRadiusStart - (_foundCount * FLO_IntelBaseRadiusStep)) max FLO_IntelBaseRadiusMin;
private _base = _target get "object";
private _basePos = getPosWorld _base;
private _center = [_basePos, random (_radius * 0.55), random 360] call BIS_fnc_relPos;
private _baseType = _target get "type";
private _label = [_baseType, "FOB"] select (_baseType isEqualTo "FOB");

FLO_IntelBaseFinds set [_requestSideKey, _foundCount + 1];

_center set [2, 0];

createHashMapFromArray [
    ["success", true],
    ["type", "base"],
    ["title", "Recovered Base Intel"],
    ["message", format ["Enemy %1 suspected within %2m of the marked area.", _label, round _radius]],
    ["position", _center],
    ["grid", mapGridPosition _center],
    ["radius", round _radius],
    ["markerText", format ["%1 INTEL", _label]],
    ["markerColor", "ColorOrange"],
    ["baseType", _label],
    ["ttl", FLO_IntelMarkerTtl]
]
