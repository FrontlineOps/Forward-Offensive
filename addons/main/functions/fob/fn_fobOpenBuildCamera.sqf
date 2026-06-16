params [["_fob", objNull, [objNull]]];

if (!hasInterface) exitWith {};

if (isNull _fob) exitWith {
    hint "FOB is no longer available.";
};

private _side = side group player;

if !(_side in [west, east]) exitWith {
    hint "Only BLUFOR and OPFOR can use FOB logistics.";
};

if (!([player, "logistics"] call FLO_fnc_commandPlayerHasAuthority)) exitWith {
    hint "Only the side commander can use FOB logistics right now.";
};

private _sideKey = [_side] call FLO_fnc_resourceSideKey;

if ((_fob getVariable ["FLO_FOB_SideKey", ""]) isNotEqualTo _sideKey) exitWith {
    hint "This FOB belongs to the other faction.";
};

private _buildRadius = _fob getVariable ["FLO_FOB_BuildRadius", FLO_FOBBuildRadius];

if ((player distance2D _fob) > _buildRadius) exitWith {
    hint format ["Move within %1m of this FOB to build.", _buildRadius];
};

[player] call IDS_Logistics_fnc_initBuildCamera;
