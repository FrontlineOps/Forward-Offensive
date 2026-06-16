params ["_object", "_cargoData"];

private _cargo = createHashMapFromArray _cargoData;

clearItemCargoGlobal _object;
clearWeaponCargoGlobal _object;
clearMagazineCargoGlobal _object;
clearBackpackCargoGlobal _object;

private _items = [[], []];
private _weapons = [[], []];
private _magazines = [[], []];
private _backpacks = [[], []];

if ("items" in _cargo) then {
    _items = _cargo get "items";
};

if ("weapons" in _cargo) then {
    _weapons = _cargo get "weapons";
};

if ("magazines" in _cargo) then {
    _magazines = _cargo get "magazines";
};

if ("backpacks" in _cargo) then {
    _backpacks = _cargo get "backpacks";
};

private _classes = _items # 0;
private _counts = _items # 1;

if ((count _classes) > 0) then {
    for "_i" from 0 to ((count _classes) - 1) do {
        _object addItemCargoGlobal [_classes # _i, _counts # _i];
    };
};

_classes = _weapons # 0;
_counts = _weapons # 1;

if ((count _classes) > 0) then {
    for "_i" from 0 to ((count _classes) - 1) do {
        _object addWeaponCargoGlobal [_classes # _i, _counts # _i];
    };
};

_classes = _magazines # 0;
_counts = _magazines # 1;

if ((count _classes) > 0) then {
    for "_i" from 0 to ((count _classes) - 1) do {
        _object addMagazineCargoGlobal [_classes # _i, _counts # _i];
    };
};

_classes = _backpacks # 0;
_counts = _backpacks # 1;

if ((count _classes) > 0) then {
    for "_i" from 0 to ((count _classes) - 1) do {
        _object addBackpackCargoGlobal [_classes # _i, _counts # _i];
    };
};
