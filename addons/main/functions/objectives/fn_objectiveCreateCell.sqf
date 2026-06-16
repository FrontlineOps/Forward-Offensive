params ["_objectiveId", "_definition"];

private _id = _definition get "id";
private _role = _definition get "role";
private _position = _definition get "position";
private _radius = _definition get "radius";
private _weight = _definition get "weight";

if !(_role in ["anchor", "support"]) then {
    throw format ["[FLO][Objective] Cell %1 has invalid role %2", _id, _role];
};

createHashMapFromArray [
    ["id", _id],
    ["objectiveId", _objectiveId],
    ["role", _role],
    ["position", _position],
    ["radius", _radius],
    ["weight", _weight],
    ["owner", sideUnknown],
    ["state", "neutral"],
    ["progress", 0],
    ["progressSide", sideUnknown],
    ["influenceEast", 0],
    ["influenceWest", 0],
    ["lastEvaluated", 0]
]
