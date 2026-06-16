params ["_unit", ["_killer", objNull], ["_instigator", objNull], ["_useEffects", false]];

if (!isServer) exitWith {};
if (isNull _unit) exitWith {};
if (!(_unit isKindOf "CAManBase")) exitWith {};
if !(isPlayer _unit) exitWith {};

private _side = side group _unit;

if !(_side in [west, east]) exitWith {};

private _id = netId _unit;
private _sideKey = [_side] call FLO_fnc_resourceSideKey;
private _hasIntel = (random 1) < FLO_IntelDropChance;

if (_id in FLO_IntelBodies) exitWith {};

FLO_IntelBodies set [
    _id,
    createHashMapFromArray [
        ["id", _id],
        ["object", _unit],
        ["side", _side],
        ["sideKey", _sideKey],
        ["hasIntel", _hasIntel],
        ["searched", false],
        ["searchedBy", ""],
        ["searchedAt", 0],
        ["createdAt", serverTime]
    ]
];

_unit setVariable ["FLO_Intel_BodySideKey", _sideKey, true];
_unit setVariable ["FLO_Intel_Searchable", true, true];
_unit setVariable ["FLO_Intel_RegisteredAt", serverTime, true];

[_unit] remoteExecCall ["FLO_fnc_intelAddClientAction", 0, _unit];
