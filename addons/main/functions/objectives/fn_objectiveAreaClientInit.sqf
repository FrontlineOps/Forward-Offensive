if (!hasInterface) exitWith {};

FLO_ObjectiveAreaClientHandle = [
    {
        if ((isNull player) || {!alive player}) exitWith {
            FLO_ObjectiveAreaActiveId = "";

            private _display = findDisplay FLO_ObjectiveAreaDialogIdd;
            if (!isNull _display) then {
                _display closeDisplay 0;
            };
        };

        private _playerSide = side group player;

        if !(_playerSide in [west, east]) exitWith {
            FLO_ObjectiveAreaActiveId = "";

            private _display = findDisplay FLO_ObjectiveAreaDialogIdd;
            if (!isNull _display) then {
                _display closeDisplay 0;
            };
        };

        private _nearestId = [] call FLO_fnc_objectiveNearestAreaId;

        if (_nearestId isEqualTo "") exitWith {
            if (FLO_ObjectiveAreaActiveId isNotEqualTo "") then {
                FLO_ObjectiveAreaActiveId = "";

                private _display = findDisplay FLO_ObjectiveAreaDialogIdd;
                if (!isNull _display) then {
                    _display closeDisplay 0;
                };
            };
        };

        if (_nearestId isNotEqualTo FLO_ObjectiveAreaActiveId) then {
            FLO_ObjectiveAreaActiveId = _nearestId;
        };

        if (!isNull (findDisplay FLO_ObjectiveAreaDialogIdd)) then {
            [] call FLO_fnc_objectiveUpdateAreaDialog;
        };
    },
    2,
    []
] call CBA_fnc_addPerFrameHandler;
