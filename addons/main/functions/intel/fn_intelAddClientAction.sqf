params [["_body", objNull, [objNull]]];

if (!hasInterface) exitWith {};
if (isNull _body) exitWith {};
if (_body getVariable ["FLO_Intel_ClientActionAdded", false]) exitWith {};

private _actionId = _body addAction [
    FLO_IntelSearchActionText,
    {
        params ["_target"];

        [_target] call FLO_fnc_intelOpenDialog;
    },
    [],
    7,
    true,
    true,
    "",
    "alive _this && {!alive _target} && {(_this distance2D _target) <= FLO_IntelSearchDistance} && {_target getVariable ['FLO_Intel_Searchable', false]} && {(side group _this) in [west, east]} && {([side group _this] call FLO_fnc_resourceSideKey) isNotEqualTo (_target getVariable ['FLO_Intel_BodySideKey', ''])}",
    FLO_IntelSearchDistance,
    false,
    "",
    ""
];

_body setVariable ["FLO_Intel_ClientActionAdded", true];
_body setVariable ["FLO_Intel_ClientActionId", _actionId];
