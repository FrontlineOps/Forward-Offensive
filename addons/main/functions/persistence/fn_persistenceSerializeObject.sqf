params ["_object"];

[
    ["className", typeOf _object],
    ["posASL", getPosASL _object],
    ["dir", getDir _object],
    ["vectorDir", vectorDir _object],
    ["vectorUp", vectorUp _object],
    ["damage", damage _object],
    ["fuel", fuel _object],
    ["lock", locked _object],
    ["cargo", [_object] call FLO_fnc_persistenceSerializeCargo]
]
