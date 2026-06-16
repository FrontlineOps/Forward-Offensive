params ["_objective"];

private _incomePer15 = [_objective] call FLO_fnc_objectiveIncomePer15;
private _ticksPer15 = (900 / FLO_ResourceTickInterval) max 1;

floor (_incomePer15 / _ticksPer15)
