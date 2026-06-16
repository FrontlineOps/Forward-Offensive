params ["_side"];

allPlayers select {
    (!isNull _x) &&
    {!(_x isKindOf "HeadlessClient_F")} &&
    {(side group _x) isEqualTo _side} &&
    {(getPlayerUID _x) isNotEqualTo ""}
}
