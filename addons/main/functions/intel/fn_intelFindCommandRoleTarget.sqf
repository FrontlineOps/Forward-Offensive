params ["_enemySideKey"];

if !(_enemySideKey in FLO_CommandSideState) exitWith { createHashMap };

private _state = FLO_CommandSideState get _enemySideKey;
private _commanderUid = _state get "commanderUid";
private _roleAssignments = _state get "roleAssignments";
private _deputyUids = _roleAssignments get "deputy";
private _candidates = [];

{
    private _unit = _x;
    private _unitSide = side group _unit;

    if (alive _unit && {_unitSide in [west, east]} && {([_unitSide] call FLO_fnc_resourceSideKey) isEqualTo _enemySideKey}) then {
        private _uid = getPlayerUID _unit;

        if ((_uid isNotEqualTo "") && {_uid isEqualTo _commanderUid}) then {
            _candidates pushBack ["Commander", _unit];
        };

        if ((_uid isNotEqualTo "") && {_uid in _deputyUids}) then {
            _candidates pushBack ["Deputy Commander", _unit];
        };
    };
} forEach allPlayers;

if (_candidates isEqualTo []) exitWith { createHashMap };

private _target = selectRandom _candidates;
private _roleName = _target # 0;
private _unit = _target # 1;
private _radius = FLO_IntelCommandRoleMarkerRadius;
private _targetPos = getPosWorld _unit;
private _center = [_targetPos, random (_radius * 0.65), random 360] call BIS_fnc_relPos;

_center set [2, 0];

createHashMapFromArray [
    ["success", true],
    ["type", "commandRole"],
    ["title", "Enemy Command Intel"],
    ["message", format ["Recovered command traffic identifies enemy %1 %2 near the marked area. Location is approximate, not a precise fix.", _roleName, name _unit]],
    ["position", _center],
    ["grid", mapGridPosition _center],
    ["radius", round _radius],
    ["markerText", format ["%1 INTEL", toUpper _roleName]],
    ["markerColor", "ColorOrange"],
    ["role", _roleName],
    ["targetName", name _unit],
    ["ttl", FLO_IntelMarkerTtl]
]
