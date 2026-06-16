params ["_className", "_entryKind", "_category"];

private _cfg = configNull;

if (_entryKind isEqualTo "vehicle") then {
    _cfg = configFile >> "CfgVehicles" >> _className;
} else {
    if (_category isEqualTo "ammo") then {
        _cfg = configFile >> "CfgMagazines" >> _className;
    } else {
        if (_category isEqualTo "backpacks") then {
            _cfg = configFile >> "CfgVehicles" >> _className;
        } else {
            _cfg = configFile >> "CfgWeapons" >> _className;
        };
    };
};

private _name = getText (_cfg >> "displayName");
if (_name isEqualTo "") then {
    _name = _className;
};

private _image = getText (_cfg >> "picture");

if (_image isEqualTo "") then {
    _image = getText (_cfg >> "editorPreview");
};

private _price = [_className, _category, _entryKind] call FLO_fnc_storePriceClass;

createHashMapFromArray [
    ["className", _className],
    ["name", _name],
    ["category", _category],
    ["entryKind", _entryKind],
    ["priceValue", _price],
    ["price", format ["%1", _price]],
    ["image", _image]
]
