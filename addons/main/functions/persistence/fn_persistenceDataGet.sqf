params ["_data", "_key", ["_default", []]];

private _map = createHashMapFromArray _data;

if (_key in _map) exitWith {
    _map get _key
};

_default
