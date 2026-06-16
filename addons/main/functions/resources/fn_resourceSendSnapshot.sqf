params [["_owner", 0]];

FLO_ResourceSnapshot = [] call FLO_fnc_resourceBuildSnapshot;

if (_owner isEqualTo 0) then {
    [FLO_ResourceSnapshot] remoteExecCall ["FLO_fnc_resourceReceiveSnapshot", 0];
} else {
    [FLO_ResourceSnapshot] remoteExecCall ["FLO_fnc_resourceReceiveSnapshot", _owner];
};
