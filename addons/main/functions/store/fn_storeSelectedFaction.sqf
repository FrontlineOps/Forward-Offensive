params ["_sideKey"];

private _state = FLO_CommandSideState get _sideKey;
private _factionClass = _state get "factionClass";
private _factionName = _state get "factionName";

createHashMapFromArray [
    ["selected", _factionClass isNotEqualTo ""],
    ["class", _factionClass],
    ["name", _factionName]
]
