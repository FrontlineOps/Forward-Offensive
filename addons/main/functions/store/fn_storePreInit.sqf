FLO_StoreDialogIdd = 9800;
FLO_StoreBrowserIdc = 9801;
FLO_StoreApprovalsDialogIdd = 9820;
FLO_StoreApprovalsBrowserIdc = 9821;
FLO_StoreActiveFobNetId = "";
FLO_StoreClientPendingVehicles = [];
FLO_StorePurchasedVehicleKilledEh = -1;
FLO_StorePlaceableMagazineCache = createHashMap;
FLO_StorePlaceableMagazineCacheReady = false;
FLO_StoreDeploymentFundAmount = 1000;

FLO_StoreCategories = [
    ["primary", "Primary"],
    ["handgun", "Handgun"],
    ["secondary", "Launchers"],
    ["uniforms", "Uniforms"],
    ["vests", "Vests"],
    ["headgear", "Headgear"],
    ["facewear", "Facewear"],
    ["backpacks", "Backpacks"],
    ["ammo", "Ammo"],
    ["mines", "Mines"],
    ["misc", "Items"],
    ["cars", "Cars"],
    ["armor", "Armor"],
    ["helis", "Helicopters"],
    ["planes", "Planes"],
    ["naval", "Naval"],
    ["static", "Statics"],
    ["other", "Other"]
];

FLO_StoreCatalogCategories = FLO_StoreCategories + [
    ["attachments", "Attachments"]
];

FLO_StoreGearCategories = [
    "primary",
    "handgun",
    "secondary",
    "uniforms",
    "vests",
    "headgear",
    "facewear",
    "backpacks",
    "attachments",
    "ammo",
    "mines",
    "misc"
];

FLO_StoreVehicleCategories = [
    "cars",
    "armor",
    "helis",
    "planes",
    "naval",
    "static",
    "other"
];

FLO_StoreGearContainers = [
    "auto",
    "uniform",
    "vest",
    "backpack"
];

FLO_StoreFreeItemClasses = [
    "ace_earplugs",
    "ace_elasticbandage",
    "ace_fielddressing",
    "ace_packingbandage",
    "ace_quikclot",
    "ace_splint",
    "ace_tourniquet"
];

FLO_StoreRuntimeVariantBaseClasses = [
    "ACRE_PRC343",
    "ACRE_PRC148",
    "ACRE_PRC152",
    "ACRE_PRC77",
    "ACRE_PRC117F",
    "ACRE_SEM52SL",
    "ACRE_SEM70",
    "ACRE_BF888S"
];

FLO_StoreSupportCatalogItems = [
    ["FirstAidKit", "gear", "misc"],
    ["Medikit", "gear", "misc"],

    ["ACE_adenosine", "gear", "misc"],
    ["ACE_atropine", "gear", "misc"],
    ["ACE_bloodIV", "gear", "misc"],
    ["ACE_bloodIV_250", "gear", "misc"],
    ["ACE_bloodIV_500", "gear", "misc"],
    ["ACE_bodyBag", "gear", "misc"],
    ["ACE_EarPlugs", "gear", "misc"],
    ["ACE_elasticBandage", "gear", "misc"],
    ["ACE_epinephrine", "gear", "misc"],
    ["ACE_fieldDressing", "gear", "misc"],
    ["ACE_MapTools", "gear", "misc"],
    ["ACE_microDAGR", "gear", "misc"],
    ["ACE_morphine", "gear", "misc"],
    ["ACE_packingBandage", "gear", "misc"],
    ["ACE_personalAidKit", "gear", "misc"],
    ["ACE_plasmaIV", "gear", "misc"],
    ["ACE_plasmaIV_250", "gear", "misc"],
    ["ACE_plasmaIV_500", "gear", "misc"],
    ["ACE_quikclot", "gear", "misc"],
    ["ACE_RangeCard", "gear", "misc"],
    ["ACE_salineIV", "gear", "misc"],
    ["ACE_salineIV_250", "gear", "misc"],
    ["ACE_salineIV_500", "gear", "misc"],
    ["ACE_splint", "gear", "misc"],
    ["ACE_surgicalKit", "gear", "misc"],
    ["ACE_tourniquet", "gear", "misc"],

    ["ACRE_PRC343", "gear", "misc"],
    ["ACRE_PRC148", "gear", "misc"],
    ["ACRE_PRC152", "gear", "misc"],
    ["ACRE_PRC77", "gear", "misc"],
    ["ACRE_PRC117F", "gear", "misc"],
    ["ACRE_SEM52SL", "gear", "misc"],
    ["ACRE_SEM70", "gear", "misc"],
    ["ACRE_BF888S", "gear", "misc"],
    ["ACRE_VHF30108", "gear", "backpacks"],
    ["ACRE_VHF30108SPIKE", "gear", "backpacks"],
    ["ACRE_VHF30108MAST", "gear", "backpacks"],
    ["ACRE_VHF30108MASTB", "gear", "backpacks"],

    ["ItemGPS", "gear", "misc"]
];
