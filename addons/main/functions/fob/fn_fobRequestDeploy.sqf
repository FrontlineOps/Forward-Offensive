params ["_player"];

if (!isServer) exitWith {};
if (isNull _player) exitWith {};

private _owner = owner _player;

if ((remoteExecutedOwner > 2) && {_owner isNotEqualTo remoteExecutedOwner}) exitWith {
    diag_log format [
        "[FLO][FOB] Rejected FOB deploy request from owner %1 for owner %2",
        remoteExecutedOwner,
        _owner
    ];
};

if (!alive _player) exitWith {
    [false, "Cannot deploy a FOB while dead."] remoteExecCall ["FLO_fnc_fobReceiveDeployResult", _owner];
};

private _side = side group _player;

if !(_side in [west, east]) exitWith {
    [false, "FOBs are only available to BLUFOR and OPFOR."] remoteExecCall ["FLO_fnc_fobReceiveDeployResult", _owner];
};

if (!([_player, "fob"] call FLO_fnc_commandPlayerHasAuthority)) exitWith {
    [false, "Only the elected side commander can deploy FOBs."] remoteExecCall ["FLO_fnc_fobReceiveDeployResult", _owner];
};

private _sideKey = [_side] call FLO_fnc_resourceSideKey;
private _posASL = getPosASL _player;
private _posAGL = ASLToAGL _posASL;

if (surfaceIsWater _posAGL) exitWith {
    [false, "FOB deployment requires dry land."] remoteExecCall ["FLO_fnc_fobReceiveDeployResult", _owner];
};

private _tooClose = false;
private _sameSideFobCount = 0;

{
    private _record = FLO_FOBs get _x;

    if ((_record get "sideKey") isEqualTo _sideKey) then {
        private _fob = _record get "object";

        if ((!isNull _fob) && {alive _fob}) then {
            _sameSideFobCount = _sameSideFobCount + 1;

            if ((_fob distance2D _posAGL) < FLO_FOBMinDistance) exitWith {
                _tooClose = true;
            };
        };
    };
} forEach keys FLO_FOBs;

if (_tooClose) exitWith {
    [false, format ["Friendly FOBs must be at least %1m apart.", FLO_FOBMinDistance]] remoteExecCall ["FLO_fnc_fobReceiveDeployResult", _owner];
};

private _starterDeploy = (!(FLO_FOBStarterUsed get _sideKey)) && {_sameSideFobCount isEqualTo 0};
private _deployCost = [FLO_FOBDeployCost, 0] select _starterDeploy;

if ((_deployCost > 0) && {!([_side, _deployCost, "FOB deploy"] call FLO_fnc_resourceSpend)}) exitWith {
    [false, format ["Not enough faction currency. FOB cost: %1.", _deployCost]] remoteExecCall ["FLO_fnc_fobReceiveDeployResult", _owner];
};

private _className = FLO_FOBSideClasses get _sideKey;
private _fob = createVehicle [_className, [0, 0, 0], [], 0, "CAN_COLLIDE"];
_fob setPosASL _posASL;
_fob setDir getDir _player;
_fob allowDamage true;

[_fob, _side, getPlayerUID _player] call FLO_fnc_fobRegister;
FLO_FOBStarterUsed set [_sideKey, true];
["fobDeploy"] call FLO_fnc_persistenceScheduleSave;

private _message = if (_starterDeploy) then {
    format ["Initial FOB deployed. Build radius: %1m.", FLO_FOBBuildRadius]
} else {
    format ["FOB deployed. Build radius: %1m.", FLO_FOBBuildRadius]
};

[true, _message] remoteExecCall ["FLO_fnc_fobReceiveDeployResult", _owner];

diag_log format [
    "[FLO][FOB] %1 deployed FOB %2 at %3 cost=%4 starter=%5",
    _sideKey,
    _fob getVariable "FLO_FOB_Id",
    mapGridPosition _fob,
    _deployCost,
    _starterDeploy
];
