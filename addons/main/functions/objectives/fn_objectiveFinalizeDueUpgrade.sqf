params ["_objective"];

private _pendingLevel = floor (_objective get "pendingUpgradeLevel");

if (_pendingLevel <= 0) exitWith { false };
if (diag_tickTime < (_objective get "pendingUpgradeCompleteAt")) exitWith { false };
if ((_objective get "state") isNotEqualTo "held") exitWith { false };

_objective set ["level", _pendingLevel min FLO_ObjectiveMaxLevel];
_objective set ["lastLevelChanged", diag_tickTime];
_objective set ["pendingUpgradeLevel", 0];
_objective set ["pendingUpgradeStartedAt", 0];
_objective set ["pendingUpgradeCompleteAt", 0];

diag_log format [
    "[FLO][Objective] AO %1 completed upgrade to level %2",
    _objective get "id",
    _objective get "level"
];

true
