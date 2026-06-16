params ["_cell", "_ownerByCell"];

private _owner = _cell get "owner";
private _eastNeighbors = 0;
private _westNeighbors = 0;

{
    private _neighborOwner = _ownerByCell get _x;

    if (_neighborOwner isEqualTo east) then {
        _eastNeighbors = _eastNeighbors + 1;
    };

    if (_neighborOwner isEqualTo west) then {
        _westNeighbors = _westNeighbors + 1;
    };
} forEach (_cell get "neighborIds");

private _targetSide = sideUnknown;

if (_owner isEqualTo sideUnknown) then {
    if ((_eastNeighbors >= FLO_ObjectiveGridAoEMinOwnedNeighbors) && {_eastNeighbors > _westNeighbors}) then {
        _targetSide = east;
    };

    if ((_westNeighbors >= FLO_ObjectiveGridAoEMinOwnedNeighbors) && {_westNeighbors > _eastNeighbors}) then {
        _targetSide = west;
    };
} else {
    if ((_owner isEqualTo east) && {_westNeighbors >= FLO_ObjectiveGridEncircleMinOwnedNeighbors} && {_eastNeighbors isEqualTo 0}) then {
        _targetSide = west;
    };

    if ((_owner isEqualTo west) && {_eastNeighbors >= FLO_ObjectiveGridEncircleMinOwnedNeighbors} && {_westNeighbors isEqualTo 0}) then {
        _targetSide = east;
    };
};

_targetSide
