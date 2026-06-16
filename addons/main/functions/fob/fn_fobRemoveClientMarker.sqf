params [["_markerId", "", [""]], ["_fob", objNull, [objNull]]];

if (!hasInterface) exitWith {};
if (isMultiplayer && {remoteExecutedOwner isNotEqualTo 2} && {remoteExecutedOwner isNotEqualTo 0}) exitWith {
    diag_log format ["[FLO][FOB] Rejected FOB marker removal from owner %1", remoteExecutedOwner];
};

if (!isNull _fob) then {
    private _actionId = _fob getVariable ["FLO_FOB_IDSActionId", -1];
    if (_actionId isNotEqualTo -1) then {
        _fob removeAction _actionId;
        _fob setVariable ["FLO_FOB_IDSActionId", -1];
    };

    private _storeActionId = _fob getVariable ["FLO_FOB_StoreActionId", -1];
    if (_storeActionId isNotEqualTo -1) then {
        _fob removeAction _storeActionId;
        _fob setVariable ["FLO_FOB_StoreActionId", -1];
    };

    private _recoveryActionId = _fob getVariable ["FLO_FOB_RecoveryActionId", -1];
    if (_recoveryActionId isNotEqualTo -1) then {
        _fob removeAction _recoveryActionId;
        _fob setVariable ["FLO_FOB_RecoveryActionId", -1];
    };
};

deleteMarkerLocal _markerId;
FLO_FOBClientMarkers deleteAt _markerId;
