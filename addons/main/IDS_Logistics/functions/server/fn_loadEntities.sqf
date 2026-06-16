/**
 * @name IDS_Logistics_fnc_loadEntities
 * @category Logistics
 * 
 * @author IDSolutions
 * @version 1.0
 * @date 2025-03-10
 * 
 * @description
 * Loads all saved logistics entities from the profileNamespace.
 * Recreates entities based on saved class name, position, direction, orientation, and damage.
 *
 * @param {None}
 *
 * @return {Nothing}
 *
 * @example
 * [] call IDS_Logistics_fnc_loadEntities
 */

// This function should run on the server only
if (!isServer) exitWith {
    diag_log "IDS_Logistics_fnc_loadEntities: Must be executed on server";
};

private _savedData = missionProfileNamespace getVariable ["IDS_Logistics_SavedEntities", []];

// Check if we have any saved data
if (count _savedData == 0) exitWith {
    diag_log "IDS_Logistics_fnc_loadEntities: No saved entities found";
};

// Clear any existing placed entities
{
    deleteVehicle _x;
} forEach (IDS_Logistics_PlacedEntities + []);
IDS_Logistics_PlacedEntities = [];

// Load and recreate entities
{
    private _className = _x get "class";
    private _position = _x get "position";
    private _direction = _x get "direction";
    private _vectorUp = _x get "vectorUp";
    private _damage = _x get "damage";
    
    private _entity = createVehicle [_className, [0,0,0], [], 0, "CAN_COLLIDE"];

    _entity setPosASL _position;
    _entity setDir _direction;
    _entity setVectorUp _vectorUp;
    _entity setDamage _damage;
    _entity setVariable ["IDS_Logistics_isPlacedEntity", true, true];

    private _entityConfig = [_className] call IDS_Logistics_fnc_getEntityConfig;
    _entityConfig params ["_entityClassName", "_entityCategory", "_entityCost"];
    _entity setVariable ["IDS_Logistics_EntityCost", _entityCost, true];

    IDS_Logistics_PlacedEntities pushBack _entity;
} forEach _savedData;

diag_log format ["IDS_Logistics_fnc_loadEntities: Loaded %1 entities", count IDS_Logistics_PlacedEntities];
