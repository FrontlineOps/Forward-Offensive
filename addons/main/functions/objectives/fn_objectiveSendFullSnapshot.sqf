params [["_owner", 0]];

FLO_ObjectiveSnapshot = [] call FLO_fnc_objectiveBuildSnapshot;
FLO_ObjectiveGridSnapshot = [] call FLO_fnc_objectiveBuildGridSnapshot;

if (_owner isEqualTo 0) then {
    [FLO_ObjectiveGridSnapshot, true] remoteExecCall ["FLO_fnc_objectiveReceiveGridSnapshot", 0];
    [FLO_ObjectiveSnapshot, true] remoteExecCall ["FLO_fnc_objectiveReceiveSnapshot", 0];
} else {
    [FLO_ObjectiveGridSnapshot, true] remoteExecCall ["FLO_fnc_objectiveReceiveGridSnapshot", _owner];
    [FLO_ObjectiveSnapshot, true] remoteExecCall ["FLO_fnc_objectiveReceiveSnapshot", _owner];
};
