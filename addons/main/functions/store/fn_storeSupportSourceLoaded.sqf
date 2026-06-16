params ["_source"];

private _patches = _source select 1;

if (_patches isEqualTo []) exitWith {
    true
};

(_patches findIf {
    isClass (configFile >> "CfgPatches" >> _x)
}) >= 0
