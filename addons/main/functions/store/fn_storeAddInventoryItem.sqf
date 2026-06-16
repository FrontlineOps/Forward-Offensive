params ["_unit", "_className", "_container"];

switch (_container) do {
    case "uniform": {
        if ((uniform _unit) isEqualTo "") then {
            _unit addItem _className;
        } else {
            _unit addItemToUniform _className;
        };
    };
    case "vest": {
        if ((vest _unit) isEqualTo "") then {
            _unit addItem _className;
        } else {
            _unit addItemToVest _className;
        };
    };
    case "backpack": {
        if ((backpack _unit) isEqualTo "") then {
            _unit addItem _className;
        } else {
            _unit addItemToBackpack _className;
        };
    };
    default {
        _unit addItem _className;
    };
};

true
