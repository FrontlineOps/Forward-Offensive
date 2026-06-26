params ["_uid"];

if (!isServer) exitWith { 0 };
if (_uid isEqualTo "") exitWith { 0 };

if (_uid in FLO_StoreDeploymentFunds) exitWith {
    FLO_StoreDeploymentFunds get _uid
};

FLO_StoreDeploymentFundAmount
