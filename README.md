# FOOF.Altis

FOOF is a PvP-focused Arma 3 gamemode built for realistic, immersive, team-driven combat on Altis.

The goal is to create a hardcore milsim environment where movement, coordination, terrain control, logistics, and defensive planning matter. FOOF is not being built as an arcade capture mode. Match systems should reward maneuver, reconnaissance, pressure on flanks, and organized defense rather than simple rushes into a single capture circle.

## Current Status

FOOF is in early foundation development.

The first gameplay foundation is a server-authoritative objective system. Objectives are visible to players as recognizable locations such as towns, depots, radio sites, crossroads, or bases. Under the hood, nearby control cells create a tug-of-war layer so teams can pressure an objective by controlling approaches, support positions, and key terrain around it.

## Core Principles

- PvP first.
- Server-authoritative match state.
- Realistic movement and maneuver over arcade mechanics.
- Objectives should create fights across terrain, not just inside one marker.
- Defensive positions should matter without making the match static.

## Development

The mission is organized as an Arma 3 mission folder. Reusable systems should be implemented through `CfgFunctions` under `Functions/`.

Current foundation files:

- `description.ext`
- `initServer.sqf`
- `Functions/Objective/`
- `mission.sqm`

The project is still early, so systems and layout will evolve as the gamemode foundation is built.
