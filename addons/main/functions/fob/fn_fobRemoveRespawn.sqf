params ["_record"];

private _handle = _record get "respawnHandle";

if (_handle isNotEqualTo []) then {
    _handle call BIS_fnc_removeRespawnPosition;
    _record set ["respawnHandle", []];
};
