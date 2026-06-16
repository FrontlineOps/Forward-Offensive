params ["_payload"];

private _position = _payload get "position";
private _radius = _payload get "radius";
private _color = _payload get "markerColor";
private _text = _payload get "markerText";
private _ttl = _payload get "ttl";
private _id = format ["FLO_INTEL_%1_%2", diag_tickTime, floor random 1000000];
private _areaId = _id + "_AREA";
private _iconId = _id + "_ICON";

private _area = createMarkerLocal [_areaId, _position];
_area setMarkerShapeLocal "ELLIPSE";
_area setMarkerBrushLocal "SolidBorder";
_area setMarkerColorLocal _color;
_area setMarkerAlphaLocal 0.35;
_area setMarkerSizeLocal [_radius, _radius];

private _icon = createMarkerLocal [_iconId, _position];
_icon setMarkerTypeLocal "mil_unknown";
_icon setMarkerColorLocal _color;
_icon setMarkerTextLocal _text;
_icon setMarkerAlphaLocal 0.85;

FLO_IntelMarkers pushBack [_areaId, _iconId, diag_tickTime + _ttl];

[
    {
        params ["_areaId", "_iconId"];

        deleteMarkerLocal _areaId;
        deleteMarkerLocal _iconId;
    },
    [_areaId, _iconId],
    _ttl
] call CBA_fnc_waitAndExecute;

_id
