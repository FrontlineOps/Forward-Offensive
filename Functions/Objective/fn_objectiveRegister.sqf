params ["_definition"];

private _id = _definition get "id";
private _name = _definition get "name";
private _position = _definition get "position";
private _requiredWeightRatio = _definition get "requiredWeightRatio";
private _cellDefinitions = _definition get "cells";

if (_id in (keys FLO_Objectives)) then {
    throw format ["[FLO][Objective] Duplicate objective id: %1", _id];
};

private _anchorDefinitions = _cellDefinitions select { (_x get "role") isEqualTo "anchor" };

if ((count _anchorDefinitions) != 1) then {
    throw format ["[FLO][Objective] Objective %1 must define exactly one anchor cell", _id];
};

private _cellIds = [];

{
    private _cell = [_id, _x] call FLO_fnc_objectiveCreateCell;
    private _cellId = _cell get "id";

    if (_cellId in (keys FLO_ObjectiveCells)) then {
        throw format ["[FLO][Objective] Duplicate objective cell id: %1", _cellId];
    };

    FLO_ObjectiveCells set [_cellId, _cell];
    _cellIds pushBack _cellId;
} forEach _cellDefinitions;

private _anchorCellId = (_anchorDefinitions # 0) get "id";

FLO_Objectives set [
    _id,
    createHashMapFromArray [
        ["id", _id],
        ["name", _name],
        ["position", _position],
        ["requiredWeightRatio", _requiredWeightRatio],
        ["cellIds", _cellIds],
        ["anchorCellId", _anchorCellId],
        ["owner", sideUnknown],
        ["state", "neutral"],
        ["eastWeight", 0],
        ["westWeight", 0],
        ["totalWeight", 0],
        ["lastChanged", 0]
    ]
];

diag_log format [
    "[FLO][Objective] Registered objective %1 (%2) with %3 cells",
    _id,
    _name,
    count _cellIds
];
