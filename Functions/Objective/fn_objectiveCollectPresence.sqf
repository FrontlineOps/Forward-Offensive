private _presence = [];

{
    private _vehicle = vehicle _x;
    private _eligibleVehicle = (_vehicle isEqualTo _x) || {!(_vehicle isKindOf "Air") || {isTouchingGround _vehicle}};

    if (alive _x && {!(captive _x)} && {!((lifeState _x) isEqualTo "INCAPACITATED")} && {_eligibleVehicle}) then {
        private _side = side group _x;

        if (_side in [east, west]) then {
            _presence pushBack [_side, getPosATL _x];
        };
    };
} forEach allPlayers;

_presence
