# UBOAT Load Order Manager v1.1

**Unofficial Windows utility for UBOAT 2026.1** to switch between curated Singleplayer (49 mods) and Multiplayer (47 mods) loading orders without manually dragging every mod in the launcher.

[Deutsch / English installation guide](README_DE_EN.md) | [Release notes](RELEASE_NOTES.md) | [License](LICENSE.txt) | [Security](SECURITY.md)

> **Status:** Experimental community utility; not endorsed by Deep Water Studio, PlayWay, Steam, or individual Workshop authors. The launcher-file workaround and BAT starter have been reported to work on the maintainer's local setup, but game updates or different installations may affect them. The tool does **not** guarantee that every mod combination is compatible.

## Features

- One-click `Switch_to_SP.bat` (49 mods) and `Switch_to_MP.bat` (47 mods)
- `UBOAT_LoadOrder_Manager.bat` for choosing a profile, checking status or restoring backups
- Automatically reorders **only** UBOAT's `Launcher/launcherdata` and `modlist.txt`
- Backs up both configuration files before changes, preserving mod metadata and permissions
- Verifies SP Airforce's installed `Manifest.json` identity when its Steam Workshop folder is found
- No installation, administrator privileges, game assets, downloads or network connection needed
- Human-readable profiles and auditable PowerShell source code

## Quick start / Schnellstart

1. Subscribe to all mods in the [SP collection](https://steamcommunity.com/sharedfiles/filedetails/?id=3825264904) or [MP collection](https://steamcommunity.com/sharedfiles/filedetails/?id=3824775264) and finish all Steam downloads. / Alle Mods der gewünschten Kollektion abonnieren.
2. Open the UBOAT launcher once to register mods. **Close both UBOAT and its launcher completely.** / Launcher einmal öffnen, dann Spiel und Launcher vollständig schließen.
3. Download the ZIP from [GitHub Releases](../../releases), **extract it fully** to its own folder (do not run inside the ZIP). / ZIP vollständig entpacken.
4. Double-click `Switch_to_SP.bat` or `Switch_to_MP.bat`, or use the menu BAT. / Passende BAT-Datei doppelklicken.
5. Launch UBOAT normally through Steam. **Verify the actual active mod order in its launcher and start a new career.** / Im Launcher Reihenfolge kontrollieren und neue Kampagne starten.

### What it changes

| File | Purpose |
| --- | --- |
| `%USERPROFILE%\AppData\LocalLow\Deep Water Studio\UBOAT\Launcher\launcherdata` | Order of launcher-registered mod entries (metadata preserved) |
| `%USERPROFILE%\AppData\LocalLow\Deep Water Studio\UBOAT\modlist.txt` | Active mod IDs in selected SP/MP order |
| `%USERPROFILE%\AppData\LocalLow\Deep Water Studio\UBOAT\LoadOrderBackups` | Automatic timestamped backup copies |

The tool **does not** edit saved games, Workshop manifests, game binaries, account data, or any system-wide PowerShell policy. BAT files launch the included `.ps1` with a process-scoped execution-policy override. Review the source before running any downloaded script.

**Airforce SP warning:** The *Allied Aircraft Bundle* and *German Aircraft Bundle* are asset sources only. Copy **only their `Bundles` contents** into Airforce. **Never copy either aircraft package's `Manifest.json`** into the Airforce folder.

**Seakeeping MP warning:** Its Workshop dependency on Historical Weather Overhaul can cause Steam to subscribe to that extra mod; keep Historical Weather Overhaul disabled for MP. Co-op sync and every other gameplay mod combination remain unverified.

## Repository files

- `UBOAT_LoadOrder_Manager.ps1` — complete source code
- `Switch_to_SP.bat`, `Switch_to_MP.bat`, `UBOAT_LoadOrder_Manager.bat` — Windows launchers
- `profiles/SP.txt`, `profiles/MP.txt` — editable ID lists
- `steam/` — complete bilingual Steam Workshop collection descriptions and load orders
- `README_DE_EN.md` — detailed DE/EN instructions and caveats
- `CHANGELOG.md`, `RELEASE_NOTES.md`, `SECURITY.md`, `CONTRIBUTING.md` — project documentation

## Downloads, support and licensing

Download versioned archives from **Releases**, not from the green **Code > Download ZIP** button, to get an explicitly published release. Always verify that a release is from the repository owner. For problems, read [the troubleshooting guide](README_DE_EN.md) and open an issue with the tool version, SP/MP choice and the error message (redact private filesystem data first).

MIT license, copyright (c) 2026 UBOAT Load Order Manager contributors. Before publishing under your own GitHub identity, update the copyright holder if desired. The license covers only this tool's original code/documentation; it does **not** license UBOAT, Steam, third-party Workshop mods or external aircraft assets. See [third-party notices](THIRD_PARTY_NOTICES.md).
