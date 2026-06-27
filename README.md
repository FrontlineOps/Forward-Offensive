# FOOF

## About

A PvP-focused Arma 3 milsim gamemode for realistic whole-map terrain control, maneuver, and team-driven combat.

## Project Status

FOOF is in early foundation development.

The current foundation is a server-authoritative objective system with a generated land-only sector grid. Major locations act as high-value objectives while surrounding grid cells create a tug-of-war layer for flanks, approaches, defensive depth, encirclement, and spearhead movement.

FOOF currently requires CBA_A3.

## License and Reuse

FOOF is public for visibility, development tracking, and official release access, but it is not open source.

Forward Offensive, also known as FOOF, is proprietary and all rights are reserved by Frontline Operations Development Group. No permission is granted to copy, modify, redistribute, reupload, repack, host, sell, sublicense, or create derivative versions of this project without prior written permission.

Official public releases may be downloaded and used only for playing Forward Offensive through authorized releases, servers, or events.

See `LICENSE.md` for the full license terms.

## Features

- Persistent 24/7 PvP campaign state
- Grid-based territory control across the map
- Major AO system for towns, villages, ports, terminals, capitals, and strategic areas
- Frontline-focused capture rules
- AO pressure and assault windows
- AO command panel for side-wide held AO upgrades
- FOB and COP deployment systems
- Commander voting and faction selection
- Faction-based Store with weapons, gear, kits, support items, and FOB-only vehicle purchases
- Faction-derived default spawn kits
- Commander reinforcement ticket purchases from the FOB/COP deployment panel
- Personal and faction currency income from controlled territory
- AO upgrade levels that increase value and defensive strength
- Ticket-based respawns
- Friendly FOB/COP respawn network
- Intel system for searching enemy bodies
- Notification and announcement framework

## Development

- Addon root: `addons/main`
- Addon config: `addons/main/config.cpp`
- Event adapter: `addons/main/functions/events/`
- Command/faction voting: `addons/main/functions/command/`
- Objective system: `addons/main/functions/objectives/`
- Resource system: `addons/main/functions/resources/`
- FOB/COP base system: `addons/main/functions/fob/`
- Spawn/deployment system: `addons/main/functions/spawns/`
- Store system: `addons/main/functions/store/`
- Ticket system: `addons/main/functions/tickets/`
- Notification system: `addons/main/functions/notifications/`
- Intel system: `addons/main/functions/intel/`
- IDS Logistics: `addons/main/IDS_Logistics/`
- Command vote UI: `addons/main/ui/command/`
- Deployment UI: `addons/main/ui/deploy/`
- Intel UI: `addons/main/ui/intel/`
- Store UI: `addons/main/ui/store/`
- AO command UI: `addons/main/ui/objective/`
- Startup: addon `postInit` during normal missions; Arma engine intro missions are skipped.
- Dev test mission: `missions/FOOF_Test.Altis`

Gameplay systems should subscribe to CBA `FLO_event*` events instead of adding their own raw Bohemia mission event handlers. The only raw mission event adapter should live in `addons/main/functions/events/`. UI display input handlers may still use Arma display handlers where that is the correct UI API.

## Building and Testing

Use HEMTT to build or launch the FOOF addon with CBA_A3. The default launch profile opens the included Altis test mission shell, but the addon systems are registered from `addons/main` and are not tied to root mission files.

Any playable mission shell used to host FOOF needs respawn configured as custom positions with `MenuPosition`, respawn dialog enabled, and respawn on start disabled; the included test shell and root dev shell both include those settings.

HEMTT project config is included for local addon checks and launch workflow.

```powershell
.\.tools\hemtt\hemtt.exe check
.\.tools\hemtt\hemtt.exe build --no-bin --no-rap
.\.tools\hemtt\hemtt.exe launch
```

## Objective and AO Upgrades

The objective system is server-authoritative. Clients receive sanitized objective/grid snapshots for map markers and UI, but the server owns objective state, capture state, upgrade timers, resource spending, and persistence.

`Ctrl+Shift+O` opens the AO command panel from anywhere. The panel lists all friendly held AOs for the player's side, shows level, income, pressure, vulnerability, pending upgrade time, faction balance, remote upgrade price, and in-person upgrade price. The same dialog includes a native Arma map preview: hovering an AO row focuses/highlights that AO, and clicking a friendly held AO on the map selects it in the panel.

Commander/build-authorized players can request AO upgrades remotely from the panel at full price. If the requester is physically inside the selected AO, the server applies the in-person upgrade discount. The current remote formula is `nextLevel * resourceWeight * 1500`, rounded up to the nearest `$100`; the current in-person discount is `25%`.

The server validates request owner, player life state, side, AO ownership, held state, command authority, max level, pending upgrade state, physical proximity for discount eligibility, and faction balance before spending money or starting the upgrade timer.

## Store Purchases

Territory income is split by the server every resource tick: 90% of generated side income goes to that side's faction balance, and each active same-side player receives a personal grant equal to 10% of that side income. The 10% personal grant is per player, not divided between players.

Store checkout spends eligible deployment fund first, then personal funds. If a normal player cannot cover the remaining gear cost with personal funds, the checkout is queued for commander/deputy approval and the approved shortfall spends faction funds. Vehicle purchases are always queued for commander/deputy approval unless the buyer is already the commander or deputy.

Only the commander and deputy can spend faction funds from Store approval. Pending approvals are shown in the Store approval panel and are revalidated server-side before gear is applied or vehicle placement records are created.

The client checks carried inventory capacity before submitting packable item checkout lines, so full uniforms, vests, or backpacks reject the checkout before any money is spent. Server checkout still owns catalog, balance, approval, and vehicle authority.

Store-purchased uniforms, vests, backpacks, and vehicles are stripped of inherited class cargo before use. Only gear explicitly bought through the cart is added to player containers, and purchased vehicles spawn with empty cargo inventory while retaining their normal vehicle weapons and turrets.

## Default Spawn Kits

Fresh, non-persisted players receive a default kit from their side's selected faction. The server picks the first usable infantry unit from faction-authored data: `CfgGroups` unit order first, then playable `CfgVehicles` infantry fallback. A candidate only needs to be a valid infantry class with a usable unit loadout.

The chosen unit classname is sent to the owning client through the server-authorized default-kit apply function, which uses Arma's class-based unit loadout support. Persisted player loadouts remain authoritative and are not replaced by default kits.

### Resetting Persistence

FOOF persistence lives under the server's `missionProfileNamespace` key for the active world. Deleting profile files while the mission is running can fail because the live server state may save itself again.

From a server-side console:

```sqf
[true, "admin reset"] call FLO_fnc_persistenceResetServer;
```

From a logged-in admin client debug console:

```sqf
[player, true] remoteExecCall ["FLO_fnc_persistenceRequestReset", 2];
```

Both forms disable persistence, stop the persistence save loop, clear the active save key, flush `missionProfileNamespace`, and notify players when the first argument is `true`. Complete the wipe by restarting the dedicated server process from the host panel. Arma's in-game `#restart` only restarts the mission and can reload stale mission-profile state.

## Known Issues

FOOF is not gameplay-complete yet. Respawn waves, victory rules, external persistence backends, and full match flow are still foundation work.
