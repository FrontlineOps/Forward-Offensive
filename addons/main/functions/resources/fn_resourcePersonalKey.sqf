params ["_sideOrKey", "_uid"];

private _sideKey = if ((typeName _sideOrKey) isEqualTo "STRING") then {
    _sideOrKey
} else {
    [_sideOrKey] call FLO_fnc_resourceSideKey
};

if !(_sideKey in ["WEST", "EAST"]) then {
    throw format ["[FLO][Resource] Invalid personal balance side: %1", _sideKey];
};

if (_uid isEqualTo "") then {
    throw "[FLO][Resource] Personal balance requires a player UID";
};

format ["%1:%2", _sideKey, _uid]
