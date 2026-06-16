params ["_className"];

private _lowerClass = toLower _className;

(FLO_StoreSupportRejectPatterns findIf {
    private _needle = toLower _x;
    (_needle isNotEqualTo "") && {_lowerClass find _needle >= 0}
}) >= 0
