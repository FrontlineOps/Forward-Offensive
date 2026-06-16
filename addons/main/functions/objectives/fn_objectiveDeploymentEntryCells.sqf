params ["_seedCellId"];

private _seedCell = FLO_ObjectiveCells get _seedCellId;
private _cellIds = [_seedCellId];

{
    _cellIds pushBackUnique _x;
} forEach (_seedCell get "cardinalNeighborIds");

_cellIds
