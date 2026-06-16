params ["_snapshot", ["_fullRefresh", true]];

if (!hasInterface) exitWith {};

if (_fullRefresh) then {
    FLO_ObjectiveClientObjectiveRecords = createHashMap;
};

{
    FLO_ObjectiveClientObjectiveRecords set [_x # 0, _x];
} forEach _snapshot;

FLO_ObjectiveClientLastSnapshot = values FLO_ObjectiveClientObjectiveRecords;

[_snapshot, _fullRefresh] call FLO_fnc_objectiveUpdateMapMarkers;
