params ["_control"];

if (!hasInterface) exitWith {};

private _playerSide = side group player;

if !(_playerSide in [west, east]) exitWith {};

private _playerSideKey = [_playerSide] call FLO_fnc_resourceSideKey;
private _activeId = FLO_ObjectiveAreaActiveId;
private _hoverId = FLO_ObjectiveAreaHoverId;
private _records = values FLO_ObjectiveClientObjectiveRecords;
private _icon = "\A3\ui_f\data\map\markers\military\dot_CA.paa";

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
        "_displayRadius",
        "_level",
        "_levelName",
        "_incomePer10",
        "_remoteUpgradeCost",
        "_maxLevel",
        ["_pendingUpgradeLevel", 0],
        ["_pendingUpgradeRemaining", 0],
        ["_capturedRestoreOwnerKey", "NONE"],
        ["_capturedRestoreLevel", 0],
        ["_capturedRestoreRemaining", 0],
        ["_frontline", false],
        ["_pressureWest", 0],
        ["_pressureEast", 0],
        ["_vulnerableSideKey", "NONE"],
        ["_vulnerableRemaining", 0],
        ["_inPersonUpgradeCost", 0]
    ];

    if ((_ownerKey isEqualTo _playerSideKey) && {_objectiveState isEqualTo "held"}) then {
        private _color = [0.35, 0.86, 1, 0.42];
        private _lineAlpha = 0.35;
        private _iconSize = 20;
        private _textSize = 0.035;
        private _text = format ["L%1 %2", _level, _name];

        if (_objectiveId isEqualTo _activeId) then {
            _color = [0.65, 1, 0.35, 0.82];
            _lineAlpha = 0.75;
            _iconSize = 26;
            _textSize = 0.043;
        };

        if (_objectiveId isEqualTo _hoverId) then {
            _color = [0.15, 0.85, 1, 0.95];
            _lineAlpha = 0.9;
            _iconSize = 30;
            _textSize = 0.047;
        };

        _control drawEllipse [_position, _displayRadius, _displayRadius, 0, [_color # 0, _color # 1, _color # 2, _lineAlpha], ""];
        _control drawIcon [_icon, _color, _position, _iconSize, _iconSize, 0, _text, 1, _textSize, "RobotoCondensedBold", "right"];
    };
} forEach _records;
