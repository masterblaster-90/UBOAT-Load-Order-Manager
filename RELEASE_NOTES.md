# Release v1.1 — UBOAT Load Order Manager

**Unofficial Windows tool for UBOAT 2026.1.** Choose one of two loading orders without reordering 47/49 mods manually.

### Included

- `Switch_to_SP.bat`: 49-mod Singleplayer profile
- `Switch_to_MP.bat`: 47-mod Multiplayer profile
- `UBOAT_LoadOrder_Manager.bat`: menu, status and restore
- PowerShell source (`.ps1`), profile lists, bilingual instructions and Steam BBCode templates
- Automatic backups of `launcherdata` and `modlist.txt`

### Installation

1. Subscribe to the mods from the corresponding [SP](https://steamcommunity.com/sharedfiles/filedetails/?id=3825264904) or [MP](https://steamcommunity.com/sharedfiles/filedetails/?id=3824775264) Steam collection; let Steam finish downloading.
2. Open the UBOAT launcher once; then fully close both the launcher and UBOAT.
3. **Extract this release ZIP completely** and run the desired BAT as a normal user (no administrator rights).
4. Start UBOAT through Steam, check enabled mods and their order, then use a **new campaign**.

### Limitations

- Experimental workaround for launcher ordering; could be affected by game updates and different mod installations.
- Co-op gameplay and every third-party mod combination are **not** guaranteed to be synchronized or conflict-free.
- For SP Airforce, install aircraft assets manually as the mod author requires, without overwriting Airforce's `Manifest.json`.
- No third-party UBOAT or Steam assets are distributed; this archive is only the open-source profile manager.

### Verification

Source, JSON rewrite logic, IDs and metadata preservation were structurally audited against a 99-entry launcher file. The BAT launcher was reported working on one Windows installation. Further independent end-to-end testing is encouraged; please file issues with reproducible logs (after removing personal data).

License: MIT. See `LICENSE.txt` and `THIRD_PARTY_NOTICES.md`.
