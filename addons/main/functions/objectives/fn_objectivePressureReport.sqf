params [
    "_objective",
    "_event",
    ["_attackerSide", sideUnknown, [sideUnknown]]
];

private _name = _objective get "name";
private _owner = _objective get "owner";
private _defenderPayload = createHashMap;
private _attackerPayload = createHashMap;

switch (_event) do {
    case "frontline": {
        if (_owner in [west, east]) then {
            _defenderPayload = createHashMapFromArray [
                ["mode", "notify"],
                ["title", "AO"],
                ["message", format ["%1 is on the contact line.", _name]],
                ["type", "info"],
                ["duration", 6]
            ];
            [_owner, _defenderPayload] call FLO_fnc_notificationSendSide;

            private _enemySide = [east, west] select (_owner isEqualTo east);
            _attackerPayload = createHashMapFromArray [
                ["mode", "notify"],
                ["title", "AO"],
                ["message", format ["%1 is on the contact line.", _name]],
                ["type", "info"],
                ["duration", 6]
            ];
            [_enemySide, _attackerPayload] call FLO_fnc_notificationSendSide;
        };
    };
    case "vulnerable": {
        if ((_owner in [west, east]) && {_attackerSide in [west, east]}) then {
            _defenderPayload = createHashMapFromArray [
                ["mode", "announce"],
                ["title", "Command"],
                ["message", format ["Assault window open at %1. Reinforce immediately.", _name]],
                ["type", "warning"],
                ["duration", 8]
            ];
            [_owner, _defenderPayload] call FLO_fnc_notificationSendSide;

            _attackerPayload = createHashMapFromArray [
                ["mode", "announce"],
                ["title", "Command"],
                ["message", format ["Assault window open at %1.", _name]],
                ["type", "announcement"],
                ["duration", 8]
            ];
            [_attackerSide, _attackerPayload] call FLO_fnc_notificationSendSide;
        };
    };
    case "windowClosed": {
        if ((_owner in [west, east]) && {_attackerSide in [west, east]}) then {
            _defenderPayload = createHashMapFromArray [
                ["mode", "notify"],
                ["title", "AO"],
                ["message", format ["Assault window closed at %1.", _name]],
                ["type", "success"],
                ["duration", 6]
            ];
            [_owner, _defenderPayload] call FLO_fnc_notificationSendSide;

            _attackerPayload = createHashMapFromArray [
                ["mode", "notify"],
                ["title", "Command"],
                ["message", format ["Assault window closed at %1.", _name]],
                ["type", "warning"],
                ["duration", 6]
            ];
            [_attackerSide, _attackerPayload] call FLO_fnc_notificationSendSide;
        };
    };
};
