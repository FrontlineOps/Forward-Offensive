params [["_fob", objNull, [objNull]]];

if (!hasInterface) exitWith {};

if (isNull _fob) exitWith {
    hint "Base is no longer available.";
};

private _side = side group player;

if !(_side in [west, east]) exitWith {
    hint "Only BLUFOR and OPFOR can use base logistics.";
};

if (!([player, "logistics"] call FLO_fnc_commandPlayerHasAuthority)) exitWith {
    hint "Only the side commander can use base logistics right now.";
};

private _sideKey = [_side] call FLO_fnc_resourceSideKey;

if ((_fob getVariable ["FLO_FOB_SideKey", ""]) isNotEqualTo _sideKey) exitWith {
    hint "This base belongs to the other faction.";
};

private _buildRadius = _fob getVariable ["FLO_FOB_BuildRadius", FLO_FOBBuildRadius];

if ((player distance2D _fob) > _buildRadius) exitWith {
    hint format ["Move within %1m of this base to build.", _buildRadius];
};

missionNamespace setVariable ["FLO_LogisticsActiveBaseId", _fob getVariable ["FLO_FOB_Id", ""]];
missionNamespace setVariable ["FLO_LogisticsActiveCategories", +(_fob getVariable ["FLO_FOB_LogisticsCategories", []])];

[player] call IDS_Logistics_fnc_initBuildCamera;
