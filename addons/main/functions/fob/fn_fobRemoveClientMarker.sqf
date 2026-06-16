params [["_markerId", "", [""]]];

if (!hasInterface) exitWith {};

deleteMarkerLocal _markerId;
FLO_FOBClientMarkers deleteAt _markerId;
