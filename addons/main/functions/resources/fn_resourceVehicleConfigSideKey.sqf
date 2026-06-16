params [["_className", "", [""]]];

private _cfg = configFile >> "CfgVehicles" >> _className;

if !(isClass _cfg) exitWith { "" };

switch (getNumber (_cfg >> "side")) do {
    case 0: { "EAST" };
    case 1: { "WEST" };
    default { "" };
}
