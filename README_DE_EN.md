# UBOAT Load Order Manager v1.1

Portable, plain-text Windows utility to switch between **UBOAT 2026.1** SP (49 mods) and MP (47 mods) load-order profiles. It has not been officially approved or supported by the UBOAT developers.

## DE — Installation in 1 Minute

1. ZIP vollständig in einen eigenen Ordner entpacken (nicht direkt aus der ZIP starten).
2. Alle Mods der gewünschten Steam-Kollektion abonnieren, Downloads abschließen und **den UBOAT-Launcher einmal öffnen** (damit Mods in `launcherdata` registriert werden).
3. UBOAT und Launcher **vollständig schließen**.
4. `Switch_to_SP.bat` oder `Switch_to_MP.bat` doppelklicken. Alternativ `UBOAT_LoadOrder_Manager.bat` für das Menü öffnen.
5. Erfolgsmeldung abwarten, UBOAT normal über Steam starten, Lade-Reihenfolge im Launcher und `modlist.txt` prüfen. Eine neue Kampagne verwenden.
6. Im Menü lassen sich **Status prüfen** und **Backups wiederherstellen**.

### Sicherheit und Verhalten

- Das Programm verändert nur `%USERPROFILE%\AppData\LocalLow\Deep Water Studio\UBOAT\Launcher\launcherdata` und `...\UBOAT\modlist.txt`.
- Originaldateien werden **vor** dem Schreiben in `...\UBOAT\LoadOrderBackups` gesichert. Nach einem Schreibfehler stellt das Skript die vorherigen Dateien automatisch wieder her.
- Die bekannten, aber nicht aktivierten Mod-Einträge bleiben mit ihren Versionsangaben und Berechtigungen erhalten; nur die Reihenfolge der Einträge wird angepasst.
- Keine Administratorrechte notwendig. Keine Internetverbindung, kein Mod-Download und keine Installation durch das Tool.
- Die BAT-Dateien starten die mitgelieferte, offen einsehbare PS1. `-ExecutionPolicy Bypass` gilt nur für den gestarteten Prozess und verändert keine dauerhafte Richtlinie.
- **Wichtig:** Manuelle Änderungen an Workshop-Dateien (insbesondere `Manifest.json`) werden weder repariert noch verursacht. `Switch_to_SP` prüft, wenn gefunden, die Airforce-Manifestidentität (Workshop-ID 3743332401); bei Abweichung wird der Profilwechsel abgebrochen.
- Falls die Steam-Bibliothek einen ungewöhnlichen Pfad hat, kann für die zusätzliche Manifestprüfung optional die Umgebungsvariable `UBOAT_WORKSHOP_CONTENT` auf den Ordner `...\steamapps\workshop\content` gesetzt werden. Das ist für den normalen Profilwechsel nicht erforderlich.
- Das ist ein experimenteller **Launcher-Workaround**, kein offizielles UBOAT-Feature. Ein erfolgreiches Schreiben beweist noch nicht, dass jeder Spielstart die Konfiguration übernimmt. Bitte im Launcher kontrollieren.

### SP vs. MP

- SP: Shared Bundles for Entities (`2898164268`), **Airforce (`3743332401`)**, Historical Weather Overhaul (`3761081574`).
- MP: Coop Multiplayer (`3815285055`), keine der drei SP-only Mods.
- Beide: More Accurate Periscope Sights (`2471078847`).
- **Airforce:** Die zusätzlichen Aircraft-Bundles dienen nur als Quelle der Assets. **Nur den Inhalt ihrer `Bundles`-Ordner** nach Airforce kopieren, niemals ihre `Manifest.json`.
- MP: Seakeeping ist weiterhin enthalten, obwohl seine Multiplayer-Kompatibilität nicht abschließend belegt ist und Steam Weather Overhaul als Abhängigkeit abonnieren kann. Weather Overhaul im MP-Launcher deaktiviert lassen.

## EN — Quick start

1. Extract the ZIP to a normal folder (not inside the archive).
2. Subscribe to all required Steam Workshop mods and open the UBOAT launcher at least once, then fully close game and launcher.
3. Double-click `Switch_to_SP.bat` or `Switch_to_MP.bat`, or run `UBOAT_LoadOrder_Manager.bat` for an interactive menu.
4. Review the result, launch through Steam, verify active mod order and `modlist.txt`, then start a fresh career.
5. The menu can display status or restore previous backups.

The program reorders only `launcherdata` and `modlist.txt`, with automatic backup and rollback on write failure. It does not touch saves, download mods, install assets, require elevated permissions or access the network. PowerShell source is included for review. On standard Steam libraries, the SP switch also checks for the documented case of a mismatched Airforce `Manifest.json`.

## Publishing / Veröffentlichung auf Steam

A Steam Workshop collection cannot execute an external `.bat` through its **Subscribe to All** button. Recommended approach:

1. Publish this source and ZIP on a public download page, e.g. a versioned GitHub Release. Do not link to a ChatGPT sandbox URL; those are not public download links for Steam users.
2. In `steam/SP_Collection_Complete_BBCode.txt` and `steam/MP_Collection_Complete_BBCode.txt`, replace every `YOUR_PUBLIC_TOOL_DOWNLOAD_URL` with the real public ZIP link or release page URL.
3. Paste the **full BBCode source** into the corresponding Steam Collection description editor; save and reload. Both include the proper numbered `steam:ID  |  Name` load-order lists.
4. If only fixing the old MP ID-only block, replace that entire section with `steam/MP_Replace_OLD_LoadOrder_BBCode.txt`.
5. Optionally create a Steam Community Guide for longer troubleshooting steps, and link it from both collections.

**Collection links:**
- SP: https://steamcommunity.com/sharedfiles/filedetails/?id=3825264904
- MP: https://steamcommunity.com/sharedfiles/filedetails/?id=3824775264

**Status of testing:** The source format, SP/MP data (49/47 IDs), file integrity preservation, and JSON reordering were validated against the supplied 99-item `launcherdata` structure. The tool author has since reported that the packaged BAT starter works on their Windows setup; this is a limited user-reported test rather than a complete independent end-to-end or gameplay compatibility certification. Recheck SP, MP, status and backup restore before public distribution.

**License:** MIT license applies only to the manager's own code/docs, not UBOAT or any Workshop mods/assets.

## GitHub publishing

See [`README.md`](README.md) for the repository landing page and [`PUBLISHING_GUIDE_DE.md`](PUBLISHING_GUIDE_DE.md) for the account, privacy, release and Steam-link checklist. Release notes are in [`RELEASE_NOTES.md`](RELEASE_NOTES.md).
