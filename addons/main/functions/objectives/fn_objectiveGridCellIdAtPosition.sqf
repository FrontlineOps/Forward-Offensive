params ["_position"];

private _xIndex = floor ((_position # 0) / FLO_ObjectiveGridCellSize);
private _yIndex = floor ((_position # 1) / FLO_ObjectiveGridCellSize);

_xIndex = (_xIndex max 0) min (FLO_ObjectiveGridWidth - 1);
_yIndex = (_yIndex max 0) min (FLO_ObjectiveGridHeight - 1);

[_xIndex, _yIndex] call FLO_fnc_objectiveGridCellId
