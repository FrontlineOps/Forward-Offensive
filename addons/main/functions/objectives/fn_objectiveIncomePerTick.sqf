params ["_objective"];

private _incomePer10 = [_objective] call FLO_fnc_objectiveIncomePer10;
private _ticksPer10 = (600 / FLO_ResourceTickInterval) max 1;

floor (_incomePer10 / _ticksPer10)
