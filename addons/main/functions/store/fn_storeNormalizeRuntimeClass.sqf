params ["_className"];

if ((typeName _className) isNotEqualTo "STRING") exitWith { "" };
if (_className isEqualTo "") exitWith { "" };

private _lowerClass = toLower _className;
private _normalized = _className;

{
    private _baseClass = _x;
    private _lowerBase = toLower _baseClass;

    if ((_lowerClass isEqualTo _lowerBase) || {_lowerClass find (_lowerBase + "_") == 0}) exitWith {
        _normalized = _baseClass;
    };
} forEach FLO_StoreRuntimeVariantBaseClasses;

_normalized
