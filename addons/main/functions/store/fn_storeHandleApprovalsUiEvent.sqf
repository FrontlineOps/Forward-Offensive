params ["_control", "_isConfirmDialog", "_message"];

private _eventData = fromJSON _message;
private _event = _eventData get "event";
private _data = createHashMap;

if ("data" in _eventData) then {
    _data = _eventData get "data";
};

switch (_event) do {
    case "storeApprovals::ready": {
        uiNamespace setVariable ["FLO_StoreApprovalsControl", _control];
        [player] remoteExecCall ["FLO_fnc_storeRequestApprovalSnapshot", 2];
    };
    case "storeApprovals::refresh": {
        [player] remoteExecCall ["FLO_fnc_storeRequestApprovalSnapshot", 2];
    };
    case "storeApprovals::decision": {
        private _approvalId = "";
        private _approved = false;

        if ("id" in _data) then {
            _approvalId = _data get "id";
        };

        if ("approved" in _data) then {
            _approved = _data get "approved";
        };

        [player, _approvalId, _approved] remoteExecCall ["FLO_fnc_storeRequestApprovalDecision", 2];
    };
    case "storeApprovals::close": {
        closeDialog 0;
    };
    default {
        diag_log format ["[FLO][Store] Unhandled approvals UI event: %1", _event];
    };
};

true
