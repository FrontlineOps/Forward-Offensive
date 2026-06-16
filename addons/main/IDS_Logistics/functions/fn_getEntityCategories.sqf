/**
 * @name IDS_Logistics_fnc_getEntityCategories
 * @category Logistics_Core
 * 
 * @author IDSolutions
 * @version 1.0
 * @date 2025-03-15
 * 
 * @description
 * Retrieves all unique categories from the entities configuration.
 * Can work with either the cached entities array or directly from config.
 *
 * @param {Boolean} _useConfig - (Optional) Whether to fetch directly from config
 *
 * @return {Array} - Array of unique category names
 *
 * @example
 * _categories = [] call IDS_Logistics_fnc_getEntityCategories;
 * _categories = [true] call IDS_Logistics_fnc_getEntityCategories;
 */

params [["_useConfig", false, [false]]];

private _categories = [];

// If direct config lookup is requested
if (_useConfig) then {
    private _addonConfig = configFile >> "CfgLogistics" >> "Entities";
    
    for "_i" from 0 to (count _addonConfig - 1) do {
        private _entityClass = _addonConfig select _i;
        
        if (isClass _entityClass) then {
            private _category = getText (_entityClass >> "category");
            
            if !(_category in _categories) then {
                _categories pushBack _category;
            };
        };
    };
} else {
    {
        private _category = _x select 1;
        
        if !(_category in _categories) then {
            _categories pushBack _category;
        };
    } forEach IDS_Logistics_Entities;
};

_categories sort true;

_categories 
