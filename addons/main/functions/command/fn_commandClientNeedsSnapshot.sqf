if (!hasInterface) exitWith { false };
if !([] call FLO_fnc_commandCanOpenVoteDialog) exitWith { false };

private _sideKey = [side group player] call FLO_fnc_resourceSideKey;

if !("sideKey" in FLO_CommandSnapshot) exitWith { true };

(FLO_CommandSnapshot get "sideKey") isNotEqualTo _sideKey
