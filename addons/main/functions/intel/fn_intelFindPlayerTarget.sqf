params ["_player", "_body", "_enemySideKey"];

private _bodyPos = getPosWorld _body;
private _nearby = [];
private _fallback = [];

{
    private _unitSide = side group _x;

    if (alive _x && {_unitSide in [west, east]} && {([_unitSide] call FLO_fnc_resourceSideKey) isEqualTo _enemySideKey}) then {
        _fallback pushBack _x;

        if ((_x distance2D _bodyPos) <= FLO_IntelPlayerSearchRadius) then {
            _nearby pushBack _x;
        };
    };
} forEach allPlayers;

private _pool = [_fallback, _nearby] select (_nearby isNotEqualTo []);

if (_pool isEqualTo []) exitWith { createHashMap };

private _target = selectRandom _pool;
private _targetPos = getPosWorld _target;
private _radius = FLO_IntelPlayerMarkerRadius;
private _center = [_targetPos, random (_radius * 0.55), random 360] call BIS_fnc_relPos;
private _contactCount = count _pool;

_center set [2, 0];

createHashMapFromArray [
    ["success", true],
    ["type", "players"],
    ["title", "Enemy Movement Intel"],
    ["message", format ["Enemy movement signs recovered. Contacts suspected within %1m of the marked area.", round _radius]],
    ["position", _center],
    ["grid", mapGridPosition _center],
    ["radius", round _radius],
    ["contacts", _contactCount],
    ["markerText", "CONTACT INTEL"],
    ["markerColor", "ColorYellow"],
    ["ttl", FLO_IntelMarkerTtl]
]
