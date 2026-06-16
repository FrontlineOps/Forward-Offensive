params [["_fob", objNull, [objNull]]];

if (!hasInterface) exitWith {};
if (isNull _fob) exitWith {};

[
    {
        params ["_fob"];

        isNull _fob
        || {!alive _fob}
        || {
            !isNull player
            && {(side group player) in [west, east]}
            && {(_fob getVariable ["FLO_FOB_Id", ""]) isNotEqualTo ""}
            && {(_fob getVariable ["FLO_FOB_SideKey", ""]) isNotEqualTo ""}
        }
    },
    {
        params ["_fob"];

        if (isNull _fob) exitWith {};

        private _id = _fob getVariable ["FLO_FOB_Id", ""];
        private _sideKey = _fob getVariable ["FLO_FOB_SideKey", ""];
        private _markerId = format ["FLO_FOB_%1", _id];

        if (!alive _fob) exitWith {
            [_markerId] call FLO_fnc_fobRemoveClientMarker;
        };

        private _playerSideKey = [side group player] call FLO_fnc_resourceSideKey;

        if (_sideKey isNotEqualTo _playerSideKey) exitWith {
            [_markerId] call FLO_fnc_fobRemoveClientMarker;
        };

        private _marker = "";

        if (_markerId in FLO_FOBClientMarkers) then {
            _marker = FLO_FOBClientMarkers get _markerId;
        } else {
            _marker = createMarkerLocal [_markerId, getPos _fob];
            FLO_FOBClientMarkers set [_markerId, _marker];
        };

        private _baseType = _fob getVariable ["FLO_FOB_Type", "FOB"];
        private _isEast = _sideKey isEqualTo "EAST";
        private _sideName = ["BLUFOR", "OPFOR"] select _isEast;

        _marker setMarkerPosLocal (getPos _fob);
        _marker setMarkerShapeLocal "ICON";
        _marker setMarkerTypeLocal (["b_installation", "o_installation"] select _isEast);
        _marker setMarkerColorLocal (["ColorWEST", "ColorEAST"] select _isEast);
        _marker setMarkerTextLocal format ["%1 %2", _sideName, _baseType];
    },
    [_fob]
] call CBA_fnc_waitUntilAndExecute;
