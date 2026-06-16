private _body = objectFromNetId FLO_IntelActiveBodyNetId;
private _grid = "";
private _distance = -1;
private _searchable = false;
private _bodySideKey = "";

if (!isNull _body) then {
    _grid = mapGridPosition _body;
    _distance = round (player distance2D _body);
    _searchable = (!alive _body) && {_body getVariable ["FLO_Intel_Searchable", false]};
    _bodySideKey = _body getVariable ["FLO_Intel_BodySideKey", ""];
};

createHashMapFromArray [
    ["success", true],
    ["state", "ready"],
    ["type", "ready"],
    ["title", "Field Intel"],
    ["message", "Enemy casualty available for search."],
    ["bodyGrid", _grid],
    ["distance", _distance],
    ["searchable", _searchable],
    ["bodySideKey", _bodySideKey],
    ["searchDistance", FLO_IntelSearchDistance]
]
