if ((toLower missionName) in ["intro", "introexp"]) exitWith {};

[] call FLO_fnc_clientDisableChatChannels;
[] call FLO_fnc_clientConfigureAcre;
