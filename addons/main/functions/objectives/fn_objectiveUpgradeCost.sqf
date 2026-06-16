params ["_objective"];

private _level = floor (_objective get "level");

if (_level >= FLO_ObjectiveMaxLevel) exitWith { 0 };

private _nextLevel = _level + 1;
private _weight = _objective get "resourceWeight";

ceil ((_nextLevel * _weight * FLO_ObjectiveUpgradeCostPerWeightLevel) / 100) * 100
