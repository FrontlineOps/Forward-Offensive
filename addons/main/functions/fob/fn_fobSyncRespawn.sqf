params ["_id"];

if (!isServer) exitWith {};
if !(_id in FLO_FOBs) exitWith {};

private _record = FLO_FOBs get _id;

if !(_record get "respawnEnabled") exitWith {
    [_record] call FLO_fnc_fobRemoveRespawn;
};

private _object = _record get "object";

if ((isNull _object) || {!alive _object}) exitWith {
    [_record] call FLO_fnc_fobRemoveRespawn;
};

private _side = _record get "side";
private _active = true;

if ((_record get "type") isEqualTo "COP") then {
    private _enemyNear = {
        alive _x && {side group _x in [west, east]} && {side group _x isNotEqualTo _side} && {(_x distance2D _object) <= (_record get "enemyDisableRadius")}
    } count allPlayers > 0;
    private _cell = [getPosATL _object] call FLO_fnc_objectiveGridCellAtPosition;
    private _cellOwned = (_cell get "owner") isEqualTo _side;
    private _cellStable = (_cell get "state") isEqualTo "held";

    _active = !_enemyNear && {_cellOwned} && {_cellStable};
};

private _handle = _record get "respawnHandle";

if (_active) then {
    if (_handle isEqualTo []) then {
        private _sideName = ["BLUFOR", "OPFOR"] select (_side isEqualTo east);
        private _label = format ["%1 %2", _sideName, _record get "type"];
        _record set ["respawnHandle", [_side, _object, _label] call BIS_fnc_addRespawnPosition];
    };
} else {
    [_record] call FLO_fnc_fobRemoveRespawn;
};
