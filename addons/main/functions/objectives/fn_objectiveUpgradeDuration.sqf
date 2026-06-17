params ["_level"];

private _levelIndex = (floor _level) max 0;

if (_levelIndex >= count FLO_ObjectiveUpgradeDurations) exitWith {
    FLO_ObjectiveUpgradeDurations select -1
};

FLO_ObjectiveUpgradeDurations select _levelIndex
