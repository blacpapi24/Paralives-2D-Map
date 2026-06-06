# Developer notes

Internal notes on how the mod is built and how to maintain it after a Paralives update.
End-user install/usage lives in README.md.

## Overview

A BepInEx 5 (Unity Mono, x64) script mod for Paralives. It adds a flat 2D town map on a
hotkey (F7 by default) as a lighter alternative to the vanilla 3D town view. The map renders
a top-down snapshot of the town with a clickable marker per lot: left-click moves the camera
to a lot, double-click switches to that lot's household. Free, with a single optional,
silenceable support line.

## Architecture

The design keeps game-specific code isolated so a game update breaks in one predictable place:

- `Plugin.cs` — BepInEx entry point, config, and `MapRunner` (a MonoBehaviour on its own
  GameObject that owns the hotkey handling and the window). The plugin component itself is not
  ticked by Paralives, hence the separate GameObject.
- `GameBridge.cs` — all game access, via reflection. `LotInfo` is a plain data type the UI
  reads, so the window is decoupled from game internals. Member names are constants at the top
  of the file; update them there if a game patch renames something.
- `MapWindow.cs` — the IMGUI window: snapshot/image/schematic background, lot markers,
  zoom/pan, hover, and click handling.
- `MapCamera.cs` — renders the town top-down into a texture once per open/refresh (not every
  frame), and projects world positions to that image for marker placement.
- `HarmonyPatches.cs` — forces `InputManager.IsPointerOverUI` to report true while the map is
  open, so world input does not leak to the game; plus optional vanilla town-view suppression.

## Game data model (for updating after a patch)

Game code is in `Paralives.dll` (not `Assembly-CSharp.dll`, which is a stub). Lots are keyed
by a `ulong` GUID:

- `LotManager.Instance.Lots` -> `List<AssetLot>`
- `AssetLot.GUID` (from the `AssetData` base)
- `LotManager.Instance.GetLotPosition(ulong)` -> `Vector3`
- `LotManager.Instance.GetLotSurface(AssetLot)` -> `float` (area; used for marker size)
- `LotManager.Instance.ZoomToMiddleLot(AssetLot, int)` (left-click "view")
- `HouseholdManager.Instance.OwnsLot(ulong)` -> `bool` (owned colouring/glow)
- `HouseholdManager.Instance.GetHouseholdOwnerOfLot(ulong)` -> `AssetHousehold`
- Switching household: `HouseholdManager.CurrentHousehold` is derived from
  `SavedGameManager.Instance.CurrentSavedGame.Data.CurrentHouseholdGUID`; set that field, then
  select the household's characters and refresh impostors.

## Possible future work

- Parafolk dots: enumerate the housed-Para collection, project positions through the same
  camera as the lots. Unhoused Paras may need a separate lookup.
- Fast travel: `FastTravelMethods.DoFastTravel(...)` and `LotManager.LoadSpecialLot(ulong)`
  drive visits to community/commercial lots. Residential visits are not generally supported.
- Right-click "edit lot" / build mode is event-driven (`SetPlayerLotModeEvent`) and not wired.

## Compatibility / distribution

BepInEx 5, Unity Mono, x64. Script mods cannot go on the Steam Workshop; distribute via Nexus
or the in-game Plugin Hub. Expect to revisit the member names in `GameBridge.cs` after major
game updates; the reflection layer keeps a rename from hard-crashing the game.
