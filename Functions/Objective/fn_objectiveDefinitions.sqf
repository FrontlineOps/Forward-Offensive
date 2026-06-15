/*
    Defines the MVP objective topology for FOOF.

    Mission makers should edit this file first when laying out a round.
    Named objectives are player-facing. Cells are the server-side tug-of-war
    substrate used to derive objective ownership.
*/

[
    createHashMapFromArray [
        ["id", "kavala_depot"],
        ["name", "Kavala Depot"],
        ["position", [3685, 13120, 0]],
        ["requiredWeightRatio", 0.55],
        ["cells", [
            createHashMapFromArray [["id", "kavala_depot_anchor"], ["role", "anchor"], ["position", [3685, 13120, 0]], ["radius", 140], ["weight", 1]],
            createHashMapFromArray [["id", "kavala_depot_north"], ["role", "support"], ["position", [3685, 13370, 0]], ["radius", 120], ["weight", 0.35]],
            createHashMapFromArray [["id", "kavala_depot_south"], ["role", "support"], ["position", [3685, 12870, 0]], ["radius", 120], ["weight", 0.35]],
            createHashMapFromArray [["id", "kavala_depot_east"], ["role", "support"], ["position", [3935, 13120, 0]], ["radius", 120], ["weight", 0.35]],
            createHashMapFromArray [["id", "kavala_depot_west"], ["role", "support"], ["position", [3435, 13120, 0]], ["radius", 120], ["weight", 0.35]]
        ]]
    ],
    createHashMapFromArray [
        ["id", "agios_crossroads"],
        ["name", "Agios Crossroads"],
        ["position", [9187, 15947, 0]],
        ["requiredWeightRatio", 0.55],
        ["cells", [
            createHashMapFromArray [["id", "agios_crossroads_anchor"], ["role", "anchor"], ["position", [9187, 15947, 0]], ["radius", 140], ["weight", 1]],
            createHashMapFromArray [["id", "agios_crossroads_north"], ["role", "support"], ["position", [9187, 16197, 0]], ["radius", 120], ["weight", 0.35]],
            createHashMapFromArray [["id", "agios_crossroads_south"], ["role", "support"], ["position", [9187, 15697, 0]], ["radius", 120], ["weight", 0.35]],
            createHashMapFromArray [["id", "agios_crossroads_east"], ["role", "support"], ["position", [9437, 15947, 0]], ["radius", 120], ["weight", 0.35]],
            createHashMapFromArray [["id", "agios_crossroads_west"], ["role", "support"], ["position", [8937, 15947, 0]], ["radius", 120], ["weight", 0.35]]
        ]]
    ],
    createHashMapFromArray [
        ["id", "pyrgos_radio"],
        ["name", "Pyrgos Radio"],
        ["position", [16830, 12620, 0]],
        ["requiredWeightRatio", 0.55],
        ["cells", [
            createHashMapFromArray [["id", "pyrgos_radio_anchor"], ["role", "anchor"], ["position", [16830, 12620, 0]], ["radius", 140], ["weight", 1]],
            createHashMapFromArray [["id", "pyrgos_radio_north"], ["role", "support"], ["position", [16830, 12870, 0]], ["radius", 120], ["weight", 0.35]],
            createHashMapFromArray [["id", "pyrgos_radio_south"], ["role", "support"], ["position", [16830, 12370, 0]], ["radius", 120], ["weight", 0.35]],
            createHashMapFromArray [["id", "pyrgos_radio_east"], ["role", "support"], ["position", [17080, 12620, 0]], ["radius", 120], ["weight", 0.35]],
            createHashMapFromArray [["id", "pyrgos_radio_west"], ["role", "support"], ["position", [16580, 12620, 0]], ["radius", 120], ["weight", 0.35]]
        ]]
    ]
]
