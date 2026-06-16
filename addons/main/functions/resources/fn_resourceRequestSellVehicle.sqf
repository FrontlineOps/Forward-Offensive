params [
    ["_player", objNull, [objNull]],
    ["_fobNetId", "", [""]]
];

if (!isServer) exitWith {};
if (isNull _player) exitWith {};

private _owner = owner _player;
private _requestOwner = remoteExecutedOwner;

if (_requestOwner <= 2) then {
    _requestOwner = _owner;
};

private _notify = {
    params ["_message", ["_type", "info"]];

    [_player, createHashMapFromArray [
        ["mode", "notify"],
        ["type", _type],
        ["title", "Vehicle Recovery"],
        ["message", _message],
        ["duration", 5]
    ]] call FLO_fnc_notificationSendPlayer;
};

if ((_requestOwner > 2) && {_owner isNotEqualTo _requestOwner}) exitWith {
    diag_log format [
        "[FLO][Resource] Rejected spoofed vehicle recovery player=%1 requestOwner=%2 actualOwner=%3",
        name _player,
        _requestOwner,
        _owner
    ];
};

if (!alive _player) exitWith {
    ["You must be alive to recover a vehicle.", "warning"] call _notify;
};

private _side = side group _player;

if !(_side in [west, east]) exitWith {
    ["Vehicle recovery is only available to BLUFOR and OPFOR.", "warning"] call _notify;
};

private _sideKey = [_side] call FLO_fnc_resourceSideKey;
private _fob = objectFromNetId _fobNetId;

if (isNull _fob) exitWith {
    ["Base is no longer available.", "error"] call _notify;
};

if (!alive _fob) exitWith {
    ["Base is destroyed.", "error"] call _notify;
};

private _fobId = _fob getVariable ["FLO_FOB_Id", ""];

if ((_fobId isEqualTo "") || {!(_fobId in FLO_FOBs)}) exitWith {
    ["Vehicle recovery must be requested from a registered base.", "error"] call _notify;
};

private _fobRecord = FLO_FOBs get _fobId;

if ((_fobRecord get "object") isNotEqualTo _fob) exitWith {
    ["Base registration mismatch.", "error"] call _notify;
};

if ((_fobRecord get "sideKey") isNotEqualTo _sideKey) exitWith {
    ["This base belongs to the other side.", "error"] call _notify;
};

private _buildRadius = _fobRecord get "buildRadius";

if ((_player distance2D _fob) > _buildRadius) exitWith {
    ["Move closer to the base to recover vehicles.", "warning"] call _notify;
};

if !([_player, "logistics"] call FLO_fnc_commandPlayerHasAuthority) exitWith {
    ["Only logistics-authorized players can recover vehicles.", "warning"] call _notify;
};

private _bestId = "";
private _bestRecord = createHashMap;
private _bestVehicle = objNull;
private _bestDistance = 999999;
private _bestFound = false;
private _bestClassName = "";
private _bestOriginalPrice = 0;
private _bestSource = "";
private _bestOwnerSideKey = "";
private _nearVehicles = nearestObjects [getPosATL _player, ["AllVehicles"], 45];

{
    private _vehicle = _x;

    if (
        !isNull _vehicle
        && {alive _vehicle}
        && {!(_vehicle isKindOf "Man")}
        && {(_vehicle getVariable ["FLO_FOB_Id", ""]) isEqualTo ""}
        && {!(_vehicle getVariable ["IDS_Logistics_isPlacedEntity", false])}
        && {(_vehicle distance2D _fob) <= _buildRadius}
        && {(_vehicle distance2D _player) <= 45}
        && {(crew _vehicle) isEqualTo []}
    ) then {
        private _className = typeOf _vehicle;
        private _assetId = _vehicle getVariable ["FLO_Store_AssetId", ""];
        private _record = createHashMap;
        private _registered = false;
        private _ownerSideKey = "";
        private _originalPrice = 0;
        private _source = "";

        if ((_assetId isNotEqualTo "") && {_assetId in FLO_StorePurchasedVehicles}) then {
            _record = FLO_StorePurchasedVehicles get _assetId;
            _registered = ((_record get "object") isEqualTo _vehicle) && {!(_record get "sold")};
        };

        if (_registered) then {
            _ownerSideKey = _record get "sideKey";
            _originalPrice = _record get "originalPrice";

            if (_ownerSideKey isEqualTo _sideKey) then {
                _source = "friendly";
            } else {
                if (_ownerSideKey in ["WEST", "EAST"]) then {
                    _source = "enemy";
                };
            };
        } else {
            private _meta = [_className] call FLO_fnc_resourceVehicleRecoveryMeta;
            _ownerSideKey = _meta # 0;

            if ((_ownerSideKey in ["WEST", "EAST"]) && {_ownerSideKey isNotEqualTo _sideKey}) then {
                _originalPrice = _meta # 2;

                if (_originalPrice > 0) then {
                    _source = "enemy";
                };
            };
        };

        private _distance = _vehicle distance2D _player;

        if ((_source isNotEqualTo "") && {_originalPrice > 0} && {_distance < _bestDistance}) then {
            _bestDistance = _distance;
            _bestFound = true;
            _bestId = _assetId;
            _bestRecord = _record;
            _bestVehicle = _vehicle;
            _bestClassName = _className;
            _bestOriginalPrice = _originalPrice;
            _bestSource = _source;
            _bestOwnerSideKey = _ownerSideKey;
        };
    };
} forEach _nearVehicles;

if (!_bestFound) exitWith {
    ["No recoverable empty friendly purchased or enemy vehicle is close enough.", "warning"] call _notify;
};

private _damageFactor = (1 - (damage _bestVehicle)) max 0.20;
private _fuelFactor = 0.70 + ((fuel _bestVehicle) * 0.30);
private _moneyReturn = (ceil (((_bestOriginalPrice * FLO_ResourceVehicleSellbackRate * _damageFactor * _fuelFactor) max 25) / 10)) * 10;

if ((_bestId isNotEqualTo "") && {_bestId in FLO_StorePurchasedVehicles}) then {
    _bestRecord set ["sold", true];
    FLO_StorePurchasedVehicles deleteAt _bestId;
};

deleteVehicle _bestVehicle;

[_side, _moneyReturn, "Vehicle recovery"] call FLO_fnc_resourceAdd;

diag_log format [
    "[FLO][Resource] %1 recovered vehicle source=%2 owner=%3 class=%4 return=%5 base=%6",
    _sideKey,
    _bestSource,
    _bestOwnerSideKey,
    _bestClassName,
    _moneyReturn,
    _fobId
];

["vehicleRecovery"] call FLO_fnc_persistenceScheduleSave;

[
    format [
        "Recovered %1%2 for $%3.",
        ["", "enemy "] select (_bestSource isEqualTo "enemy"),
        getText (configFile >> "CfgVehicles" >> _bestClassName >> "displayName"),
        _moneyReturn
    ],
    "success"
] call _notify;
