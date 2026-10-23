# Security Policy

## Scope and support

This is a small, unofficial Windows BAT/PowerShell utility. It edits only two UBOAT user-configuration files and creates backups. It is not an anti-cheat, security product, official Steam client or UBOAT mod.

Supported public tool release: **v1.1** (UBOAT 2026.1 profile format). No security or compatibility guarantees are made for future game updates.

## Safe use

- Download only from this repository's own **GitHub Releases**.
- Inspect the plain-text `.bat` and `.ps1` files before executing them. Never run unfamiliar, modified scripts from third-party download mirrors.
- Completely close UBOAT and the launcher before switching profiles.
- Back up game saves separately; this utility backs up launcher files, **not** saves.
- Do not run as Administrator. No admin privileges, credentials, external processes, or network connection should be necessary.
- If a downloaded file or release behaves differently from the public source, **do not execute it**.

## Reporting issues privately

If you discover a security vulnerability, prefer the GitHub repository's **Security > Report a vulnerability** feature if the maintainer has enabled private vulnerability reporting. Otherwise, contact the repository maintainer privately through a channel they have published on their GitHub profile. Do not put credentials, account details, private paths or sensitive local logs into a public Issue.

For ordinary bugs and feature requests, use GitHub Issues with sanitized details, the tool version and steps to reproduce.
