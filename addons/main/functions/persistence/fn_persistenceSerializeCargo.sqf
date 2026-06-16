params ["_object"];

[
    ["items", getItemCargo _object],
    ["weapons", getWeaponCargo _object],
    ["magazines", getMagazineCargo _object],
    ["backpacks", getBackpackCargo _object]
]
