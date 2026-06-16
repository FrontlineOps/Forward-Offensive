params ["_object", "_recordData"];

private _record = createHashMapFromArray _recordData;

_object setPosASL (_record get "posASL");

if (("vectorDir" in _record) && {"vectorUp" in _record}) then {
    _object setVectorDirAndUp [_record get "vectorDir", _record get "vectorUp"];
} else {
    _object setDir (_record get "dir");
    _object setVectorUp (_record get "vectorUp");
};

if ("damage" in _record) then {
    _object setDamage (_record get "damage");
};

if ("fuel" in _record) then {
    _object setFuel (_record get "fuel");
};

if ("lock" in _record) then {
    _object lock (_record get "lock");
};

if ("cargo" in _record) then {
    [_object, _record get "cargo"] call FLO_fnc_persistenceApplyCargo;
};
