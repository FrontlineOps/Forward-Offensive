params [
    ["_uid", "", [""]],
    ["_owner", 0, [0]],
    ["_attempt", 0, [0]]
];

if (!isServer) exitWith {};
if (_uid isEqualTo "") exitWith {};
if !(_uid in FLO_PersistencePlayerRecords) exitWith {};

private _applied = [_uid, _owner] call FLO_fnc_persistenceApplyPlayerToOwner;

if (!_applied && {_attempt < FLO_PersistenceApplyPlayerMaxRetries}) then {
    [
        {
            params ["_uid", "_owner", "_attempt"];
            [_uid, _owner, _attempt + 1] call FLO_fnc_persistenceRetryApplyPlayerToOwner;
        },
        [_uid, _owner, _attempt],
        FLO_PersistenceApplyPlayerRetryDelay
    ] call CBA_fnc_waitAndExecute;
};
