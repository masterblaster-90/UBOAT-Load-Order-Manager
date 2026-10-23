# Veröffentlichung auf GitHub und Steam – Checkliste

## Vor dem Hochladen

- [ ] Lizenz bewusst gewählt: `LICENSE.txt` enthält **MIT**. Den Copyright-Vermerk auf deinen gewünschten Entwickler-/Projekt-Namen anpassen, wenn du einen anderen Rechteinhaber nennen möchtest.
- [ ] Es werden nur die eigenen Manager-Dateien, Profile und Texte veröffentlicht. **Keine** Spielstände, fremden Aircraft-Bundles, UBOAT-Dateien, eigenen Windows-Logs oder `launcherdata` hochladen.
- [ ] Windows-BAT-Test SP, MP, STATUS, RESTORE durchgeführt. Nach Launcher- und Spielstart prüfen, ob die Reihenfolge stabil bleibt.
- [ ] Bei SP Airforce-Manifestprüfung erfolgreich und korrektes Airforce-Manifest vorhanden.
- [ ] `steam/*Collection_Complete_BBCode.txt`: `YOUR_PUBLIC_TOOL_DOWNLOAD_URL` durch die tatsächliche GitHub-Release-URL ersetzen (in zwei Dateien).
- [ ] Release Notes und README vor Veröffentlichung auf zutreffende Testergebnisse prüfen.

## GitHub ohne Vorkenntnisse

1. Auf `https://github.com/signup` persönliches kostenloses Konto erstellen; E-Mail bestätigen.
2. Unter `Settings > Password and authentication` Zwei-Faktor-Authentifizierung einrichten; Wiederherstellungscodes **offline** aufbewahren.
3. Unter `Settings > Emails` die E-Mail-Privatsphäre einschalten und optional Pushes mit privater E-Mail blockieren.
4. Neues Repository, z. B. `UBOAT-Load-Order-Manager`, Sichtbarkeit **Public**. Da die Dateien bereits vorliegen, nicht zusätzlich eine fremde LICENSE/README-Vorlage initialisieren.
5. Inhalt des vollständig entpackten Ordners **auf die Repository-Wurzelebene** hochladen: `README.md`, `.bat`, `.ps1`, `LICENSE.txt`, `profiles/`, `steam/` usw. Danach prüfen, ob der Code öffentlich lesbar ist. `README.md` sollte unten auf der Startseite erscheinen.
6. Unter `Releases > Draft a new release` das Tag `v1.1` erstellen, Titel `UBOAT Load Order Manager v1.1` vergeben, Text aus `RELEASE_NOTES.md` verwenden und das **Release-ZIP** als Attachment hochladen. Nicht nur den automatischen GitHub-Quellcode-ZIP anbieten.
7. Die Release-Seite öffentlich öffnen und den Download testen. Anschließend die Steam-BBCode-Dateien mit der Release-URL aktualisieren und beide Workshop-Collections bearbeiten. **Bei einem als Vorabversion markierten Release nicht `releases/latest` verlinken; verwende dann `/releases/tag/v1.1`.**

## Empfohlene URLs

- Repository: `https://github.com/DEIN_HANDLE/UBOAT-Load-Order-Manager`
- Stabile Release-Seite: `https://github.com/DEIN_HANDLE/UBOAT-Load-Order-Manager/releases/latest`
- Direkter Asset-Link (gleichbleibender ZIP-Dateiname vorausgesetzt): `https://github.com/DEIN_HANDLE/UBOAT-Load-Order-Manager/releases/latest/download/UBOAT_LoadOrder_Manager_v1.1_GitHub_ready.zip`

Beim Update auf eine andere Version kann der direkte ZIP-Link veralten, wenn sich der Dateiname ändert. **Die `/releases/latest`-Seite ist für reguläre, nicht als Vorabversion markierte Releases robuster.** Für eine Vorabversion einen festen `/releases/tag/v1.1`-Link verwenden.

## GitHub-Profil / Privatsphäre

- Verwende einen langfristig passenden, neutralen Entwicklernamen. Die URL enthält deinen Benutzernamen.
- Für öffentliche Repositories ist kein kostenpflichtiger GitHub-Plan erforderlich.
- Verwende ein einmaliges starkes Passwort oder eine Passkey, aktiviere 2FA und sichere Recovery Codes.
- GitHub zeigt Commits öffentlich an. Nutze die von GitHub angebotene `noreply`-Adresse, wenn die private E-Mail nicht auftauchen soll.
- Keine API-Tokens/Passwörter in ein Repository kopieren. Für den ersten Upload über die Website brauchst du weder Git noch Personal Access Tokens.

## Wichtige Abgrenzung

Eine Steam Workshop *Collection* kann ein lokales Windows-BAT nicht per Abonnieren ausführen. Die öffentliche Verteilung erfolgt als **GitHub Release** mit Link in den Collections bzw. einem Steam Community Guide. Das Tool ist kein klassischer im Spiel ladbarer UBOAT-Mod.
