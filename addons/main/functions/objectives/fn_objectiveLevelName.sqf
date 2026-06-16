params [["_level", 0, [0]]];

switch (floor _level) do {
    case 0: { "Occupied / Unstable" };
    case 1: { "Secured" };
    case 2: { "Administered" };
    case 3: { "Logistics Node" };
    case 4: { "Fortified Hub" };
    case 5: { "Regional Command Center" };
    default { "Regional Command Center" };
}
