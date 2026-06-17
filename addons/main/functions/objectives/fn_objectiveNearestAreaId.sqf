if (!hasInterface) exitWith { "" };
if ((isNull player) || {!alive player}) exitWith { "" };

private _playerSide = side group player;

if !(_playerSide in [west, east]) exitWith { "" };

private _nearestId = "";
private _nearestDistance = 999999;

{
    _x params [
        "_objectiveId",
        "_name",
        "_position",
        "_ownerKey",
        "_objectiveState",
        "_eastWeight",
        "_westWeight",
        "_totalWeight",
        "_cells",
        "_resourceWeight",
        "_locationType",
        "_displayRadius"
    ];

    private _distance = player distance2D _position;

    if ((_distance <= _displayRadius) && {_distance < _nearestDistance}) then {
        _nearestId = _objectiveId;
        _nearestDistance = _distance;
    };
} forEach (values FLO_ObjectiveClientObjectiveRecords);

_nearestId
