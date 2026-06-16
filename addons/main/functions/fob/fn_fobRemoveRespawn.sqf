params ["_record"];

private _handle = _record get "respawnHandle";

if (_handle isNotEqualTo []) then {
    _handle call BIS_fnc_removeRespawnPosition;
    _record set ["respawnHandle", []];

    diag_log format [
        "[FLO][FOB] Removed %1 respawn id=%2 side=%3",
        _record get "type",
        _record get "id",
        _record get "sideKey"
    ];
};
