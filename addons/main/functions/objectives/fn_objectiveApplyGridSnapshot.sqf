params ["_snapshot", ["_fullRefresh", true]];

if (!hasInterface) exitWith {};

FLO_ObjectiveClientLastGridSnapshot = _snapshot;

[_snapshot, _fullRefresh] call FLO_fnc_objectiveUpdateGridMapMarkers;
