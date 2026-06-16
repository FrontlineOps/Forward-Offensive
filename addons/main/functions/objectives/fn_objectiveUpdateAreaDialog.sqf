if (!hasInterface) exitWith {};

private _control = uiNamespace getVariable ["FLO_ObjectiveAreaControl", controlNull];

if (isNull _control) exitWith {};
if (!FLO_ObjectiveAreaBrowserReady) exitWith {};
if !(FLO_ObjectiveAreaActiveId in FLO_ObjectiveClientObjectiveRecords) exitWith {};

private _record = FLO_ObjectiveClientObjectiveRecords get FLO_ObjectiveAreaActiveId;

_record params [
    "_objectiveId",
    "_name",
    "_position",
    "_ownerKey",
    "_objectiveState",
    "_eastWeight",
    "_westWeight",
    "_totalWeight",
    "_cells",
    "_resourceWeight",
    "_locationType",
    "_displayRadius",
    "_level",
    "_levelName",
    "_incomePer15",
    "_upgradeCost",
    "_maxLevel"
];

private _playerSide = side group player;
private _playerSideKey = "NONE";

if (_playerSide in [west, east]) then {
    _playerSideKey = [_playerSide] call FLO_fnc_resourceSideKey;
};
private _balance = 0;

{
    if ((_x isEqualType []) && {(count _x) >= 3} && {(_x # 0) isEqualTo _playerSideKey}) exitWith {
        _balance = _x # 2;
    };
} forEach FLO_ResourceSnapshot;

private _ownerName = switch (_ownerKey) do {
    case "WEST": { "BLUFOR" };
    case "EAST": { "OPFOR" };
    default { "Neutral" };
};
private _hasAuthority = [player, "build"] call FLO_fnc_commandPlayerHasAuthority;
private _canUpgrade = (_playerSideKey isEqualTo _ownerKey) &&
    {_objectiveState isEqualTo "held"} &&
    {_level < _maxLevel} &&
    {_hasAuthority};
private _upgradeReason = "";

if (_playerSideKey isNotEqualTo _ownerKey) then {
    _upgradeReason = "Your side does not control this AO.";
} else {
    if (_objectiveState isNotEqualTo "held") then {
        _upgradeReason = "AO must be uncontested.";
    } else {
        if (_level >= _maxLevel) then {
            _upgradeReason = "AO is fully upgraded.";
        } else {
            if (!_hasAuthority) then {
                _upgradeReason = "Commander or delegated build authority required.";
            };
        };
    };
};

private _payload = createHashMapFromArray [
    ["id", _objectiveId],
    ["name", _name],
    ["owner", _ownerName],
    ["ownerKey", _ownerKey],
    ["state", _objectiveState],
    ["level", _level],
    ["levelName", _levelName],
    ["incomePer15", _incomePer15],
    ["upgradeCost", _upgradeCost],
    ["maxLevel", _maxLevel],
    ["balance", _balance],
    ["canUpgrade", _canUpgrade],
    ["upgradeReason", _upgradeReason]
];

private _script = format [
    "if (window.FOOFObjective) { window.FOOFObjective.receive(%1); }",
    toJSON _payload
];

[_control, ["ExecJS", _script]] call FLO_fnc_objectiveAreaWebAction;
