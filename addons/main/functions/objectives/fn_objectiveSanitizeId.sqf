params ["_text", ["_fallback", "objective"]];

private _chars = toArray (toLower _text);
private _out = [];
private _lastUnderscore = false;

{
    private _isNumber = _x >= 48 && {_x <= 57};
    private _isLowerLetter = _x >= 97 && {_x <= 122};

    if (_isNumber || {_isLowerLetter}) then {
        _out pushBack _x;
        _lastUnderscore = false;
    } else {
        if (!_lastUnderscore && {_out isNotEqualTo []}) then {
            _out pushBack 95;
            _lastUnderscore = true;
        };
    };
} forEach _chars;

if ((_out isNotEqualTo []) && {(_out # ((count _out) - 1)) isEqualTo 95}) then {
    _out deleteAt ((count _out) - 1);
};

private _id = toString _out;

if (_id isEqualTo "") then {
    _id = _fallback;
};

_id
