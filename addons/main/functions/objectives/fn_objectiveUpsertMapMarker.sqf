params [
    "_markerId",
    "_position",
    "_shape",
    "_type",
    "_color",
    "_alpha",
    "_size",
    "_brush",
    ["_text", ""],
    ["_direction", 0],
    ["_markerRegistry", FLO_ObjectiveClientMarkers]
];

private _marker = "";

if (_markerId in _markerRegistry) then {
    _marker = _markerRegistry get _markerId;
} else {
    _marker = createMarkerLocal [_markerId, _position];
    _markerRegistry set [_markerId, _marker];
};

_marker setMarkerPosLocal _position;
_marker setMarkerShapeLocal _shape;
_marker setMarkerColorLocal _color;
_marker setMarkerAlphaLocal _alpha;
_marker setMarkerSizeLocal _size;
_marker setMarkerDirLocal _direction;
_marker setMarkerTextLocal _text;

if (_brush isNotEqualTo "") then {
    _marker setMarkerBrushLocal _brush;
};

if (_type isNotEqualTo "") then {
    _marker setMarkerTypeLocal _type;
};

_marker
