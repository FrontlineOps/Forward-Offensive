params ["_cell", "_captureSide"];

if ((_cell get "role") isNotEqualTo "anchor") exitWith { true };
if !(_captureSide in [west, east]) exitWith { false };

private _owner = _cell get "owner";

if !(_owner in [west, east]) exitWith { true };
if (_captureSide isEqualTo _owner) exitWith { true };

private _objectiveId = _cell get "objectiveId";

if (_objectiveId isEqualTo "") exitWith { true };

private _objective = FLO_Objectives get _objectiveId;

if ((_objective get "owner") isNotEqualTo _owner) exitWith { true };
if ((_objective get "level") < FLO_ObjectiveAnchorCaptureLockLevel) exitWith { true };

((_objective get "vulnerableSide") isEqualTo _captureSide) &&
{diag_tickTime < (_objective get "vulnerableExpiresAt")}
