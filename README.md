# Paralives 2D Map

A lightweight top-down town map for Paralives. Press a key to open a flat map of every lot,
then click a lot to jump the camera to it or switch to its household. It renders the town
from above once when you open it, so it stays responsive instead of running the full 3D town
view continuously.

This is a BepInEx script mod. It's free. There's an optional support link you can silence in
the config.

## Features

- Top-down map of the whole town, drawn from a one-off render (refreshable with a button).
- Lot markers show the game's own category icons (residential, commercial, park, etc.) as circular badges.
- Your current household's lot(s) are green with a pulsing highlight.
- Hover to see the lot name and type; left-click to move the camera, double-click to switch household.
- Scroll to zoom, right-drag to pan.
- Styled to match the in-game UI. Only opens inside a loaded save.

## Install

1. Install BepInEx 5 for Unity Mono, x64 (tested against 5.4.23.5). Extract it into your
   Paralives folder so `winhttp.dll` sits next to `Paralives.exe`.
2. Launch the game once, then close it, so BepInEx creates its folders.
3. Put `Paralives2DMap.dll` in `BepInEx\plugins` (a subfolder is fine).
4. Launch, load a save, and press **F7** (or click the "Open 2D Map" button, top-left).

To confirm it loaded, check `BepInEx\LogOutput.log` for the line reporting the plugin version
and toggle key.

## Controls

- **F7** — open / close the map (configurable).
- **Left-click** a lot — move the camera to it.
- **Double-click** a lot — switch to that household.
- **Scroll** — zoom. **Right-drag** — pan. **Refresh** — re-render the top-down image.

## Config

A config file appears at `BepInEx\config\com.blacpapi24.paralives2dmap.cfg` after the first run.

- `ToggleKey` — key that opens/closes the map (default F7).
- `Use3DSnapshot`, `SnapshotResolution`, `CameraHeight`, `CameraPadding` — control the
  top-down render.
- `BackgroundImage` and the `Map` calibration values — use a custom image as the backdrop
  instead of the live render, and line up the lot markers on it.
- `SuppressVanillaTownView` — block the 3D town view while the map is open (requires the town
  view method to be set in `HarmonyPatches.cs`).
- `ShowSupportMessage`, `SupportUrl` — the optional support line.

## Building from source

You need the .NET SDK and a copy of the game.

1. Open `Paralives2DMap.csproj` and set `GameDir` to your Paralives install folder (the one
   with `Paralives.exe`).
2. Run `dotnet build -c Release` (or `build.bat`, which also copies the dll into
   `BepInEx\plugins`).
3. Output is `Paralives2DMap.dll`. If a Unity type fails to resolve, add the matching module
   DLL from `Paralives_Data\Managed` to the csproj the same way as the others.

See `DEVELOPMENT.md` for architecture and the game member names used.

## Compatibility

- BepInEx 5, Unity Mono, x64.
- Script mods can't go on the Steam Workshop; share via Nexus or the in-game Plugin Hub.
- Game updates can rename internals; if the map stops finding lots, the member names in
  `GameBridge.cs` may need updating. The reflection layer keeps that from crashing the game.

## Supporting development

This mod is free. If you'd like to support updates, you can buy me a coffee:
https://www.buymeacoffee.com/blacpap24 (silence the load message with `ShowSupportMessage = false`).
No paywall, no locked features, no in-gam