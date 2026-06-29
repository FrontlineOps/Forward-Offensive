params ["_entryKind", "_category"];

if (_entryKind isNotEqualTo "gear") exitWith { false };

_category in FLO_StoreGearCategories
