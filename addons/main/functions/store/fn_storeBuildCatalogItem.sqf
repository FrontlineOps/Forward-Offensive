params ["_className", "_entryKind", "_category"];

private _cfg = configNull;

if (_entryKind isEqualTo "vehicle") then {
    _cfg = configFile >> "CfgVehicles" >> _className;
} else {
    if (_category in ["ammo", "mines"]) then {
        _cfg = configFile >> "CfgMagazines" >> _className;
    } else {
        if (_category isEqualTo "backpacks") then {
            _cfg = configFile >> "CfgVehicles" >> _className;
        } else {
            if ((_category isEqualTo "misc") && {isClass (configFile >> "CfgMagazines" >> _className)} && {!(isClass (configFile >> "CfgWeapons" >> _className))}) then {
                _cfg = configFile >> "CfgMagazines" >> _className;
            } else {
                _cfg = configFile >> "CfgWeapons" >> _className;
            };
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
private _deploymentFundEligible = [_entryKind, _category, _price] call FLO_fnc_storeDeploymentFundEligible;
private _includedAttachments = [];

if ((_entryKind isEqualTo "gear") && {_category in ["primary", "handgun", "secondary"]}) then {
    _includedAttachments = [_className] call FLO_fnc_storeWeaponAttachments;
};

createHashMapFromArray [
    ["className", _className],
    ["name", _name],
    ["category", _category],
    ["entryKind", _entryKind],
    ["includedAttachments", _includedAttachments],
    ["deploymentFundEligible", _deploymentFundEligible],
    ["priceValue", _price],
    ["price", format ["%1", _price]],
    ["image", _image]
]
