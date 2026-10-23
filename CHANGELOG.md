# Changelog

All notable changes to this external community tool are documented here. Dates describe the tool release, not UBOAT itself.

## [1.1] - 2026-10-23

- Windows BAT launchers for direct Singleplayer (49 mods) and Multiplayer (47 mods) profile switching
- Interactive menu with status display and backup restoration
- Validation of Workshop IDs and preservation of launcher mod metadata / permissions
- Automatic backups and rollback if a write or verification fails
- Airforce manifest identity safeguard to catch mistaken aircraft-bundle manifests
- Bilingual DE/EN README and complete Steam BBCode descriptions, with ordered names and IDs
- Manual verification required after starting UBOAT: this remains an experimental launcher workaround

## Notes

- Tested structurally against a 99-entry example `launcherdata` supplied during development; basic BAT functionality was reported working by the user on a local Windows setup. No comprehensive real-game or mod-compatibility certification.
- No UBOAT binaries, Workshop mod packages, external aircraft files or other third-party assets are distributed.
