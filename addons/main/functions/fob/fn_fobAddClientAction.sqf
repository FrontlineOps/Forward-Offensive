params [["_fob", objNull, [objNull]]];

if (!hasInterface) exitWith {};
if (isMultiplayer && {remoteExecutedOwner isNotEqualTo 2} && {remoteExecutedOwner isNotEqualTo 0}) exitWith {
    diag_log format ["[FLO][FOB] Rejected FOB action sync from owner %1", remoteExecutedOwner];
};
if (isNull _fob) exitWith {};

[_fob] call FLO_fnc_fobSyncClientMarker;

if (!alive _fob) exitWith {};

private _actionRadius = FLO_FOBActionRadius;
private _existingAction = _fob getVariable ["FLO_FOB_IDSActionId", -1];

if (_existingAction isEqualTo -1) then {
    private _condition = "
        alive _this
        && {alive _target}
        && {(side group _this) in [west, east]}
        && {(_target getVariable ['FLO_FOB_Id', '']) isNotEqualTo ''}
        && {(_target getVariable ['FLO_FOB_SideKey', '']) isEqualTo ([side group _this] call FLO_fnc_resourceSideKey)}
        && {(_this distance2D _target) <= (_target getVariable ['FLO_FOB_BuildRadius', FLO_FOBBuildRadius])}
    ";

    private _actionId = _fob addAction [
        "<t size='1.45' color='#FFB84A' font='RobotoCondensedBold'>Build Menu</t>",
        {
            params ["_target"];

            [_target] call FLO_fnc_fobOpenBuildCamera;
        },
        nil,
        1.5,
        true,
        true,
        "",
        _condition,
        _actionRadius
    ];

    _fob setVariable ["FLO_FOB_IDSActionId", _actionId];
};

private _existingStoreAction = _fob getVariable ["FLO_FOB_StoreActionId", -1];

if ((_existingStoreAction isEqualTo -1) && {_fob getVariable ["FLO_FOB_StoreEnabled", false]}) then {
    private _storeCondition = "
        alive _this
        && {alive _target}
        && {(side group _this) in [west, east]}
        && {(_target getVariable ['FLO_FOB_Id', '']) isNotEqualTo ''}
        && {_target getVariable ['FLO_FOB_StoreEnabled', false]}
        && {(_target getVariable ['FLO_FOB_SideKey', '']) isEqualTo ([side group _this] call FLO_fnc_resourceSideKey)}
        && {(_this distance2D _target) <= (_target getVariable ['FLO_FOB_BuildRadius', FLO_FOBBuildRadius])}
    ";

    private _storeActionId = _fob addAction [
        "<t size='1.45' color='#72E06A' font='RobotoCondensedBold'>Store</t>",
        {
            params ["_target"];

            [_target] call FLO_fnc_storeOpenDialog;
        },
        nil,
        1.45,
        true,
        true,
        "",
        _storeCondition,
        _actionRadius
    ];

    _fob setVariable ["FLO_FOB_StoreActionId", _storeActionId];
};

private _existingRecoveryAction = _fob getVariable ["FLO_FOB_RecoveryActionId", -1];

if (_existingRecoveryAction isEqualTo -1) then {
    private _recoveryCondition = "
        alive _this
        && {alive _target}
        && {(side group _this) in [west, east]}
        && {(_target getVariable ['FLO_FOB_Id', '']) isNotEqualTo ''}
        && {(_target getVariable ['FLO_FOB_SideKey', '']) isEqualTo ([side group _this] call FLO_fnc_resourceSideKey)}
        && {(_this distance2D _target) <= (_target getVariable ['FLO_FOB_BuildRadius', FLO_FOBBuildRadius])}
    ";

    private _recoveryActionId = _fob addAction [
        "<t size='1.35' color='#25D7FF' font='RobotoCondensedBold'>Recover Vehicle</t>",
        {
            params ["_target", "_caller"];

            [_caller, netId _target] remoteExecCall ["FLO_fnc_resourceRequestSellVehicle", 2];
        },
        nil,
        1.35,
        true,
        true,
        "",
        _recoveryCondition,
        _actionRadius
    ];

    _fob setVariable ["FLO_FOB_RecoveryActionId", _recoveryActionId];
};
