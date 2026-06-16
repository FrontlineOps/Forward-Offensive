/**
 * @name IDS_Logistics_fnc_testLoadEntities
 * @category Logistics_Debug
 *
 * @author IDSolutions
 * @version 1.0
 * @date 2025-03-10
 *
 * @description
 * Test function to load saved entities from missionProfileNamespace.
 * Displays debug messages and can be executed from the debug console.
 *
 * @param {None}
 *
 * @return {Nothing}
 *
 * @example
 * [] call IDS_Logistics_fnc_testLoadEntities
 */

if (!isServer) exitWith {
    ["Run IDS logistics load testing on the server.", "warning", "Logistics Test"] call FLO_fnc_notify;
};

diag_log "[IDS_Logistics] Starting entity load test";

private _savedData = missionProfileNamespace getVariable ["IDS_Logistics_SavedEntities", []];
diag_log format ["[IDS_Logistics] Found %1 entities in saved data", count _savedData];

[] call IDS_Logistics_fnc_loadEntities;

// Wait a short time to allow server processing
[{
    // Display completion message with count of loaded entities
    diag_log format ["[IDS_Logistics] Loaded %1 entities", count IDS_Logistics_PlacedEntities];

    if (hasInterface) then {
        [format ["Entity load test complete. Loaded: %1 entities.", count IDS_Logistics_PlacedEntities], "success", "Logistics Test"] call FLO_fnc_notify;
    };
}, [], 2] call CBA_fnc_waitAndExecute; 
