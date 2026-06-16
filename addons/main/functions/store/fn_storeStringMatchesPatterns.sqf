params ["_value", "_patterns", "_mode"];

private _lowerValue = toLower _value;

(_patterns findIf {
    private _needle = toLower _x;

    if (_needle isEqualTo "") then {
        false
    } else {
        if (_mode isEqualTo "prefix") then {
            _lowerValue find _needle == 0
        } else {
            _lowerValue find _needle >= 0
        };
    };
}) >= 0
