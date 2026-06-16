params ["_position", "_halfSize"];

private _sampleDistance = _halfSize * 0.75;
private _x = _position # 0;
private _y = _position # 1;
private _samples = [
    [_x, _y, 0],
    [_x - _sampleDistance, _y, 0],
    [_x + _sampleDistance, _y, 0],
    [_x, _y - _sampleDistance, 0],
    [_x, _y + _sampleDistance, 0],
    [_x - _sampleDistance, _y - _sampleDistance, 0],
    [_x - _sampleDistance, _y + _sampleDistance, 0],
    [_x + _sampleDistance, _y - _sampleDistance, 0],
    [_x + _sampleDistance, _y + _sampleDistance, 0]
];
private _landSamples = {
    !(surfaceIsWater _x)
} count _samples;

!(surfaceIsWater _position) || {_landSamples >= FLO_ObjectiveGridMinLandSamples}
