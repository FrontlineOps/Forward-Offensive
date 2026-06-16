params [["_cellIds", FLO_ObjectiveGridCellIds]];

private _cellIds = +_cellIds;
_cellIds sort true;

private _snapshot = [];

{
    private _cell = FLO_ObjectiveCells get _x;
    private _progress = round ((_cell get "progress") * 20) / 20;

    _snapshot pushBack [
        _cell get "id",
        _cell get "position",
        _cell get "halfSize",
        [_cell get "owner"] call FLO_fnc_objectiveSideKey,
        _cell get "state",
        _progress,
        [_cell get "progressSide"] call FLO_fnc_objectiveSideKey,
        _cell get "influenceEast",
        _cell get "influenceWest"
    ];
} forEach _cellIds;

_snapshot
