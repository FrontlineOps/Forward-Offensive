params [["_state", createHashMap, [createHashMap]]];

if !("phase" in _state) exitWith { createHashMap };

private _phase = _state get "phase";
private _objectiveId = "";
private _objectiveName = "";
private _position = [0, 0, 0];
private _radius = 0;

if (_phase isEqualTo "frontline") then {
    _objectiveId = _state get "plannedObjectiveId";
    _objectiveName = _state get "plannedObjectiveName";
    _position = _state get "plannedSectorPosition";
    _radius = _state get "plannedSectorRadius";
};

if (_phase isEqualTo "operation") then {
    _objectiveId = _state get "operationObjectiveId";
    _objectiveName = _state get "operationObjectiveName";
    _position = _state get "operationSectorPosition";
    _radius = _state get "operationSectorRadius";
};

if ((_objectiveId isEqualTo "") || {!(_position isEqualType [])} || {(count _position) < 2} || {!(_radius isEqualType 0)} || {_radius <= 0}) exitWith {
    createHashMap
};

createHashMapFromArray [
    ["phase", _phase],
    ["objectiveId", _objectiveId],
    ["objectiveName", _objectiveName],
    ["position", _position],
    ["radius", _radius]
]
