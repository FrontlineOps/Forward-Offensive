if (!hasInterface) exitWith {};

FLO_ObjectiveAreaClientHandle = [
    {
        if ((isNull player) || {!alive player}) exitWith {
            FLO_ObjectiveAreaActiveId = "";
            FLO_ObjectiveAreaClosedId = "";

            if (!isNull (findDisplay FLO_ObjectiveAreaDialogIdd)) then {
                closeDialog 0;
            };
        };

        private _playerSide = side group player;

        if !(_playerSide in [west, east]) exitWith {
            FLO_ObjectiveAreaActiveId = "";
            FLO_ObjectiveAreaClosedId = "";

            if (!isNull (findDisplay FLO_ObjectiveAreaDialogIdd)) then {
                closeDialog 0;
            };
        };

        private _nearestId = "";
        private _nearestDistance = 999999;

        {
            _x params [
                "_objectiveId",
                "_name",
                "_position",
                "_ownerKey",
                "_objectiveState",
                "_eastWeight",
                "_westWeight",
                "_totalWeight",
                "_cells",
                "_resourceWeight",
                "_locationType",
                "_displayRadius"
            ];

            private _distance = player distance2D _position;

            if ((_distance <= _displayRadius) && {_distance < _nearestDistance}) then {
                _nearestId = _objectiveId;
                _nearestDistance = _distance;
            };
        } forEach (values FLO_ObjectiveClientObjectiveRecords);

        if (_nearestId isEqualTo "") exitWith {
            if (FLO_ObjectiveAreaActiveId isNotEqualTo "") then {
                FLO_ObjectiveAreaActiveId = "";
                FLO_ObjectiveAreaClosedId = "";

                if (!isNull (findDisplay FLO_ObjectiveAreaDialogIdd)) then {
                    closeDialog 0;
                };
            };
        };

        if (_nearestId isNotEqualTo FLO_ObjectiveAreaActiveId) then {
            FLO_ObjectiveAreaActiveId = _nearestId;
            FLO_ObjectiveAreaClosedId = "";
        };

        if (FLO_ObjectiveAreaClosedId isEqualTo _nearestId) exitWith {};

        if (isNull (findDisplay FLO_ObjectiveAreaDialogIdd)) then {
            [_nearestId] call FLO_fnc_objectiveOpenAreaDialog;
        } else {
            [] call FLO_fnc_objectiveUpdateAreaDialog;
        };
    },
    2,
    []
] call CBA_fnc_addPerFrameHandler;
