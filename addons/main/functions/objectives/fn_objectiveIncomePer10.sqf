params ["_objective"];

private _owner = _objective get "owner";
private _state = _objective get "state";
private _level = floor (_objective get "level");

if !(_owner in [west, east]) exitWith { 0 };
if (_state isNotEqualTo "held") exitWith { 0 };
if (_level <= 0) exitWith { 0 };

private _weight = _objective get "resourceWeight";

floor (_weight * _level * FLO_ObjectiveIncomePerWeightLevel10Min)
