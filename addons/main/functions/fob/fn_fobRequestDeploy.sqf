params ["_player", ["_baseType", "FOB", [""]]];

if (!isServer) exitWith {};
if (isNull _player) exitWith {};

private _config = [_baseType] call FLO_fnc_fobTypeConfig;
private _type = _config get "type";
private _label = _config get "label";
private _owner = owner _player;

if ((remoteExecutedOwner > 2) && {_owner isNotEqualTo remoteExecutedOwner}) exitWith {
    diag_log format [
        "[FLO][FOB] Rejected %3 deploy request from owner %1 for owner %2",
        remoteExecutedOwner,
        _owner,
        _label
    ];
};

if (!alive _player) exitWith {
    [false, format ["Cannot deploy a %1 while dead.", _label]] remoteExecCall ["FLO_fnc_fobReceiveDeployResult", _owner];
};

private _side = side group _player;

if !(_side in [west, east]) exitWith {
    [false, format ["%1s are only available to BLUFOR and OPFOR.", _label]] remoteExecCall ["FLO_fnc_fobReceiveDeployResult", _owner];
};

if (!([_player, "fob"] call FLO_fnc_commandPlayerHasAuthority)) exitWith {
    [false, format ["Only the commander or deputy can deploy %1s.", _label]] remoteExecCall ["FLO_fnc_fobReceiveDeployResult", _owner];
};

private _sideKey = [_side] call FLO_fnc_resourceSideKey;
private _posASL = getPosASL _player;
private _posAGL = ASLToAGL _posASL;

if (surfaceIsWater _posAGL) exitWith {
    [false, format ["%1 deployment requires dry land.", _label]] remoteExecCall ["FLO_fnc_fobReceiveDeployResult", _owner];
};

private _matchPhase = FLO_MatchState get "phase";
private _blockedObjectiveId = "";
private _blockedObjectiveName = "";
private _blockedObjectivePosition = [0, 0, 0];
private _blockedObjectiveRadius = 0;

if (_matchPhase isEqualTo "frontline") then {
    _blockedObjectiveId = FLO_MatchState get "plannedObjectiveId";
    _blockedObjectiveName = FLO_MatchState get "plannedObjectiveName";
    _blockedObjectivePosition = FLO_MatchState get "plannedObjectivePosition";
    _blockedObjectiveRadius = FLO_MatchState get "plannedObjectiveRadius";
};

if (_matchPhase isEqualTo "operation") then {
    _blockedObjectiveId = FLO_MatchState get "operationObjectiveId";
    _blockedObjectiveName = FLO_MatchState get "operationObjectiveName";
    _blockedObjectivePosition = FLO_MatchState get "operationObjectivePosition";
    _blockedObjectiveRadius = FLO_MatchState get "operationObjectiveRadius";
};

if (
    (_blockedObjectiveId isNotEqualTo "") &&
    {_blockedObjectiveRadius > 0} &&
    {(_posAGL distance2D _blockedObjectivePosition) <= _blockedObjectiveRadius}
) exitWith {
    [false, format ["%1s cannot be deployed inside the active operation AO: %2.", _label, _blockedObjectiveName]] remoteExecCall ["FLO_fnc_fobReceiveDeployResult", _owner];
};

private _tooClose = false;
private _sameSideFobCount = 0;
private _sameSideTypeCount = 0;
private _minDistance = _config get "minDistance";

{
    private _record = FLO_FOBs get _x;

    if ((_record get "sideKey") isEqualTo _sideKey) then {
        private _base = _record get "object";

        if ((!isNull _base) && {alive _base}) then {
            if ((_record get "type") isEqualTo "FOB") then {
                _sameSideFobCount = _sameSideFobCount + 1;
            };

            if ((_record get "type") isEqualTo _type) then {
                _sameSideTypeCount = _sameSideTypeCount + 1;
            };

            if ((_base distance2D _posAGL) < _minDistance) exitWith {
                _tooClose = true;
            };
        };
    };
} forEach keys FLO_FOBs;

if (_tooClose) exitWith {
    [false, format ["Friendly bases must be at least %1m away from this %2.", _minDistance, _label]] remoteExecCall ["FLO_fnc_fobReceiveDeployResult", _owner];
};

private _maxPerSide = _config get "maxPerSide";

if ((_maxPerSide > -1) && {_sameSideTypeCount >= _maxPerSide}) exitWith {
    [false, format ["%1 already has the maximum %2 active %3s.", _sideKey, _maxPerSide, _label]] remoteExecCall ["FLO_fnc_fobReceiveDeployResult", _owner];
};

private _validCopPlacement = true;

if (_type isEqualTo "COP") then {
    private _cell = [_posAGL] call FLO_fnc_objectiveGridCellAtPosition;
    private _friendlyNeighborCount = {
        ((FLO_ObjectiveCells get _x) get "owner") isEqualTo _side
    } count (_cell get "cardinalNeighborIds");
    _validCopPlacement = ((_cell get "owner") isEqualTo _side) || {_friendlyNeighborCount > 0};
};

if (!_validCopPlacement) exitWith {
    [false, "COPs must be placed inside friendly territory or directly on the frontline."] remoteExecCall ["FLO_fnc_fobReceiveDeployResult", _owner];
};

private _starterDeploy = (_type isEqualTo "FOB") && {!(FLO_FOBStarterUsed get _sideKey)} && {_sameSideFobCount isEqualTo 0};
private _deployCost = [_config get "deployCost", 0] select _starterDeploy;

if ((_deployCost > 0) && {!([_side, _deployCost, format ["%1 deploy", _label]] call FLO_fnc_resourceSpend)}) exitWith {
    [false, format ["Not enough faction currency. %1 cost: %2.", _label, _deployCost]] remoteExecCall ["FLO_fnc_fobReceiveDeployResult", _owner];
};

private _className = (_config get "sideClasses") get _sideKey;
private _fob = createVehicle [_className, [0, 0, 0], [], 0, "CAN_COLLIDE"];
_fob setPosASL _posASL;
_fob setDir getDir _player;
_fob allowDamage true;

[_fob, _side, getPlayerUID _player, "", _config get "buildRadius", _type] call FLO_fnc_fobRegister;

if (_type isEqualTo "FOB") then {
    FLO_FOBStarterUsed set [_sideKey, true];
};

["baseDeploy"] call FLO_fnc_persistenceScheduleSave;

private _message = if (_starterDeploy) then {
    format ["Initial FOB deployed. Build radius: %1m.", FLO_FOBBuildRadius]
} else {
    format ["%1 deployed. Build radius: %2m.", _label, _config get "buildRadius"]
};

[true, _message] remoteExecCall ["FLO_fnc_fobReceiveDeployResult", _owner];

diag_log format [
    "[FLO][FOB] %1 deployed %2 %3 at %4 cost=%5 starter=%6",
    _sideKey,
    _label,
    _fob getVariable "FLO_FOB_Id",
    mapGridPosition _fob,
    _deployCost,
    _starterDeploy
];
