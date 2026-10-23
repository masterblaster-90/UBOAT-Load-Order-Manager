# UBOAT Load Order Manager v1.1 - plain-text, open, portable.
# Use only while UBOAT and its launcher are closed. No admin rights required.
# Edits ONLY launcherdata and modlist.txt, after creating local backups.
# Tested against the structure of UBOAT 2026.1 launcherdata (modList, muted).
# Note: actual execution on Windows / UBOAT must be validated by the user.

[CmdletBinding()]
param(
    [ValidateSet('Menu', 'SP', 'MP', 'STATUS', 'RESTORE')]
    [string]$Mode = 'Menu'
)

$ErrorActionPreference = 'Stop'
$Root = Join-Path $env:USERPROFILE 'AppData\LocalLow\Deep Water Studio\UBOAT'
$LauncherPath = Join-Path $Root 'Launcher\launcherdata'
$ModlistPath = Join-Path $Root 'modlist.txt'
$BackupRoot = Join-Path $Root 'LoadOrderBackups'
$Utf8NoBom = [System.Text.UTF8Encoding]::new($false)

function Read-Profile([string]$Name, [int]$Count) {
    $File = Join-Path (Join-Path $PSScriptRoot 'profiles') ("$Name.txt")
    if (-not (Test-Path -LiteralPath $File -PathType Leaf)) {
        throw "Profile file not found: $File"
    }
    $Result = @(
        Get-Content -LiteralPath $File -Encoding UTF8 |
            ForEach-Object { $_.Trim() } |
            Where-Object { $_ -ne '' -and -not $_.StartsWith('#') }
    )
    if ($Result.Count -ne $Count) {
        throw "$Name profile contains $($Result.Count) mods, expected $Count."
    }
    $Seen = @{}
    foreach ($Id in $Result) {
        if ($Id -cnotmatch '^steam:[0-9]{10}$') { throw "Invalid $Name workshop ID: $Id" }
        if ($Seen.ContainsKey($Id)) { throw "Duplicate $Name workshop ID: $Id" }
        $Seen[$Id] = $true
    }
    return $Result
}

function Equal-Order([object[]]$A, [object[]]$B) {
    if ($A.Count -ne $B.Count) { return $false }
    return (($A -join "`n") -ceq ($B -join "`n"))
}

function Assert-GameClosed {
    $Processes = @(Get-Process -ErrorAction SilentlyContinue | Where-Object {
        $_.ProcessName -match '^UBOAT(?:\s*Launcher)?$'
    })
    if ($Processes.Count -gt 0) {
        throw 'UBOAT / its launcher is still running. Close both before continuing.'
    }
}

function Get-LauncherConfig {
    if (-not (Test-Path -LiteralPath $LauncherPath -PathType Leaf)) {
        throw "Launcher file not found: $LauncherPath"
    }
    $Config = Get-Content -LiteralPath $LauncherPath -Encoding UTF8 -Raw | ConvertFrom-Json
    if ($null -eq $Config.modList -or $null -eq $Config.muted) {
        throw 'Unexpected launcherdata structure: required fields modList/muted missing.'
    }
    $Entries = @($Config.modList)
    if ($Entries.Count -lt 1) { throw 'launcherdata has no registered mods.' }
    $Seen = @{}
    foreach ($Entry in $Entries) {
        if ([string]::IsNullOrWhiteSpace($Entry.modName)) {
            throw 'launcherdata contains an entry without modName.'
        }
        if ($Seen.ContainsKey($Entry.modName)) {
            throw "Duplicate modName in launcherdata: $($Entry.modName)"
        }
        $Seen[$Entry.modName] = $true
        if ($null -eq $Entry.lastVersion -or $null -eq $Entry.permissions) {
            throw "Unexpected mod entry structure: $($Entry.modName)"
        }
    }
    return $Config
}

function Read-ActiveIds {
    if (-not (Test-Path -LiteralPath $ModlistPath -PathType Leaf)) { return @() }
    $Ids = @(Get-Content -LiteralPath $ModlistPath -Encoding UTF8 |
        ForEach-Object { $_.Trim() } | Where-Object { $_ -ne '' })
    return $Ids
}

function Show-Status {
    $Active = @(Read-ActiveIds)
    $SP = @(Read-Profile 'SP' 49)
    $MP = @(Read-Profile 'MP' 47)
    $Config = Get-LauncherConfig
    $LauncherNames = @($Config.modList | ForEach-Object { $_.modName })

    $Name = 'CUSTOM / OTHER'
    if (Equal-Order $Active $SP) { $Name = 'SINGLEPLAYER (SP)' }
    if (Equal-Order $Active $MP) { $Name = 'MULTIPLAYER (MP)' }
    $ExpectedPrefix = @($LauncherNames | Select-Object -First $Active.Count)
    $Aligned = Equal-Order $ExpectedPrefix $Active

    Write-Host ''
    Write-Host 'Current state:' -ForegroundColor Cyan
    Write-Host "  Active profile:        $Name"
    Write-Host "  Active modlist count:  $($Active.Count)"
    Write-Host "  Registered launcher:   $($LauncherNames.Count)"
    Write-Host "  Launcher order prefix: $(if ($Aligned) {'MATCHES modlist.txt'} else {'DIFFERS from modlist.txt'})"
    Write-Host "  launcherdata:          $LauncherPath"
    Write-Host "  modlist.txt:           $ModlistPath"
    Write-Host ''
}


# Best-effort file-identity protection: avoid the documented case where an
# Allied Aircraft Bundle Manifest.json was copied over Airforce's Manifest.json.
# Supports conventional Steam libraries at drive root and optional override.
function Assert-AirforceManifest {
    $Game = '494840'
    $Mod = '3743332401'
    $Roots = New-Object 'System.Collections.Generic.List[string]'

    # Optional custom workshop content path, e.g. D:\\MySteamLibrary\\steamapps\\workshop\\content.
    if (-not [string]::IsNullOrWhiteSpace($env:UBOAT_WORKSHOP_CONTENT)) {
        [void]$Roots.Add($env:UBOAT_WORKSHOP_CONTENT)
    }

    foreach ($Drive in @(Get-PSDrive -PSProvider FileSystem)) {
        $SteamRoots = @(
            (Join-Path $Drive.Root 'SteamLibrary'),
            (Join-Path $Drive.Root 'Steam'),
            (Join-Path $Drive.Root 'Program Files (x86)\Steam'),
            (Join-Path $Drive.Root 'Program Files\Steam')
        )
        foreach ($SteamRoot in $SteamRoots) {
            [void]$Roots.Add((Join-Path $SteamRoot 'steamapps\workshop\content'))
        }
    }

    $ManifestPaths = @(
        $Roots | Select-Object -Unique | ForEach-Object {
            $Base = $_
            $PathA = Join-Path $Base "$Game\$Mod\Manifest.json"
            if (Test-Path -LiteralPath $PathA -PathType Leaf) { $PathA }
        }
    )

    if ($ManifestPaths.Count -eq 0) {
        Write-Warning 'Airforce Manifest.json not found in conventional Steam libraries; identity could not be verified.'
        Write-Warning 'Check that Airforce really appears as Airforce in the UBOAT launcher.'
        return
    }

    foreach ($ManifestPath in $ManifestPaths) {
        try {
            $Manifest = Get-Content -LiteralPath $ManifestPath -Encoding UTF8 -Raw | ConvertFrom-Json
        } catch {
            throw "Invalid Airforce Manifest.json ($ManifestPath): $($_.Exception.Message)"
        }
        $FoundId = [string]$Manifest.steamFileId
        $FoundName = [string]$Manifest.name
        if ($FoundId -ne $Mod -or $FoundName -notmatch '(?i)airforce') {
            throw ('Airforce identity mismatch: ' + $ManifestPath +
                " identifies as '$FoundName' with steamFileId '$FoundId'. " +
                'Fix the Workshop installation first. Do not copy other mods'' Manifest.json.')
        }
        Write-Host 'Airforce manifest identity: OK' -ForegroundColor Green
    }
}

function Apply-Profile([string]$ProfileName) {
    Assert-GameClosed
    if ($ProfileName -eq 'SP') { Assert-AirforceManifest }
    $Requested = if ($ProfileName -eq 'SP') {
        @(Read-Profile 'SP' 49)
    } else {
        @(Read-Profile 'MP' 47)
    }
    $Config = Get-LauncherConfig
    $OriginalEntries = @($Config.modList)
    $Index = @{}
    foreach ($Entry in $OriginalEntries) { $Index[$Entry.modName] = $Entry }

    $Missing = @($Requested | Where-Object { -not $Index.ContainsKey($_) })
    if ($Missing.Count -gt 0) {
        throw ('Workshop mods missing from launcherdata: ' + ($Missing -join ', ') +
            '. First subscribe, download, and open the UBOAT launcher once.')
    }

    $RequestedLookup = @{}
    $Reordered = New-Object 'System.Collections.Generic.List[object]'
    foreach ($Id in $Requested) {
        $RequestedLookup[$Id] = $true
        [void]$Reordered.Add($Index[$Id])
    }
    # Preserve all other registered mods (and their own relative order).
    foreach ($Entry in $OriginalEntries) {
        if (-not $RequestedLookup.ContainsKey($Entry.modName)) {
            [void]$Reordered.Add($Entry)
        }
    }
    if ($Reordered.Count -ne $OriginalEntries.Count) {
        throw 'Internal safety check failed: registered mod count changed.'
    }

    $Config.modList = $Reordered.ToArray()
    $NewJson = $Config | ConvertTo-Json -Depth 16
    $Verify = $NewJson | ConvertFrom-Json
    $Prefix = @($Verify.modList | Select-Object -First $Requested.Count |
        ForEach-Object { $_.modName })
    if (-not (Equal-Order $Prefix $Requested)) {
        throw 'Internal safety check failed: JSON order mismatch.'
    }
    # No mod metadata or permissions should be altered; just array order.
    foreach ($Entry in $Verify.modList) {
        $Original = $Index[$Entry.modName]
        if (($Entry | ConvertTo-Json -Compress -Depth 12) -cne
            ($Original | ConvertTo-Json -Compress -Depth 12)) {
            throw "Internal safety check failed: metadata differs for $($Entry.modName)."
        }
    }

    New-Item -ItemType Directory -Path $BackupRoot -Force | Out-Null
    $Stamp = Get-Date -Format 'yyyyMMdd_HHmmss_fff'
    $Suffix = [Guid]::NewGuid().ToString('N').Substring(0, 6)
    $BackupDir = Join-Path $BackupRoot "${Stamp}_${ProfileName}_${Suffix}"
    New-Item -ItemType Directory -Path $BackupDir -Force | Out-Null
    Copy-Item -LiteralPath $LauncherPath -Destination (Join-Path $BackupDir 'launcherdata')
    $HadModlist = Test-Path -LiteralPath $ModlistPath
    if ($HadModlist) {
        Copy-Item -LiteralPath $ModlistPath -Destination (Join-Path $BackupDir 'modlist.txt')
    }

    try {
        [System.IO.File]::WriteAllText($LauncherPath, $NewJson + "`r`n", $Utf8NoBom)
        [System.IO.File]::WriteAllText($ModlistPath, ($Requested -join "`r`n") + "`r`n", $Utf8NoBom)
        $WrittenConfig = Get-LauncherConfig
        $WrittenPrefix = @($WrittenConfig.modList | Select-Object -First $Requested.Count |
            ForEach-Object { $_.modName })
        $WrittenActive = @(Read-ActiveIds)
        if (-not (Equal-Order $WrittenPrefix $Requested) -or
            -not (Equal-Order $WrittenActive $Requested)) {
            throw 'Post-write verification failed.'
        }
    }
    catch {
        # Restore original data when either write or verification fails.
        Copy-Item -LiteralPath (Join-Path $BackupDir 'launcherdata') -Destination $LauncherPath -Force
        if ($HadModlist) {
            Copy-Item -LiteralPath (Join-Path $BackupDir 'modlist.txt') -Destination $ModlistPath -Force
        } elseif (Test-Path -LiteralPath $ModlistPath) {
            Remove-Item -LiteralPath $ModlistPath -Force
        }
        throw "Update failed; prior files restored. Details: $_"
    }

    Write-Host ''
    Write-Host "$ProfileName profile applied successfully!" -ForegroundColor Green
    Write-Host "  Active mods:      $($Requested.Count)"
    Write-Host "  Registered mods:  $($Reordered.Count) (all preserved)"
    Write-Host "  Backup:           $BackupDir"
    if ($ProfileName -eq 'SP') {
        Write-Host '  Airforce = steam:3743332401 (NOT Allied Aircraft Bundle steam:2894542870)'
        Write-Host '  Airforce aircraft asset files still require manual installation.'
    }
    Write-Host 'Close this window, start UBOAT, and verify its launcher order.'
    Write-Host ''
}

function Restore-Backup {
    Assert-GameClosed
    if (-not (Test-Path -LiteralPath $BackupRoot)) {
        throw 'No LoadOrderBackups directory exists.'
    }
    $Dirs = @(Get-ChildItem -LiteralPath $BackupRoot -Directory |
        Where-Object { Test-Path -LiteralPath (Join-Path $_.FullName 'launcherdata') } |
        Sort-Object Name -Descending |
        Select-Object -First 12)
    if ($Dirs.Count -eq 0) { throw 'No launcherdata backups found.' }
    Write-Host ''
    Write-Host 'Available backups (newest first):' -ForegroundColor Cyan
    for ($I = 0; $I -lt $Dirs.Count; $I++) {
        Write-Host ('  {0,2}. {1}' -f ($I + 1), $Dirs[$I].Name)
    }
    $Answer = (Read-Host 'Backup number to restore (Enter to cancel)').Trim()
    if ($Answer -eq '') { return }
    $Number = 0
    if (-not [int]::TryParse($Answer, [ref]$Number) -or
        $Number -lt 1 -or $Number -gt $Dirs.Count) {
        throw 'Invalid backup selection.'
    }
    $Selected = $Dirs[$Number - 1]
    $Sure = (Read-Host 'Restore this backup? Type YES to confirm').Trim()
    if ($Sure -cne 'YES') { Write-Host 'Canceled.'; return }

    # Also back up the present state before restoring an older backup.
    $SafetyDir = Join-Path $BackupRoot ('before_restore_' + (Get-Date -Format 'yyyyMMdd_HHmmss_fff'))
    New-Item -ItemType Directory -Path $SafetyDir -Force | Out-Null
    Copy-Item -LiteralPath $LauncherPath -Destination (Join-Path $SafetyDir 'launcherdata')
    if (Test-Path -LiteralPath $ModlistPath) {
        Copy-Item -LiteralPath $ModlistPath -Destination (Join-Path $SafetyDir 'modlist.txt')
    }

    Copy-Item -LiteralPath (Join-Path $Selected.FullName 'launcherdata') -Destination $LauncherPath -Force
    $OldList = Join-Path $Selected.FullName 'modlist.txt'
    if (Test-Path -LiteralPath $OldList) {
        Copy-Item -LiteralPath $OldList -Destination $ModlistPath -Force
    } elseif (Test-Path -LiteralPath $ModlistPath) {
        Remove-Item -LiteralPath $ModlistPath -Force
    }
    $null = Get-LauncherConfig
    Write-Host 'Backup restored.' -ForegroundColor Green
    Show-Status
}

function Invoke-Safe([scriptblock]$Action) {
    try { & $Action }
    catch {
        Write-Host ''
        Write-Host ('ERROR: ' + $_.Exception.Message) -ForegroundColor Red
        Write-Host ''
    }
}

if ($Mode -ne 'Menu') {
    try {
        switch ($Mode) {
            'SP' { Apply-Profile 'SP' }
            'MP' { Apply-Profile 'MP' }
            'STATUS' { Show-Status }
            'RESTORE' { Restore-Backup }
        }
        exit 0
    } catch {
        Write-Host ('ERROR: ' + $_.Exception.Message) -ForegroundColor Red
        exit 1
    }
}

while ($true) {
    Write-Host ''
    Write-Host '========================================' -ForegroundColor DarkCyan
    Write-Host ' UBOAT Load Order Manager  v1.1' -ForegroundColor Cyan
    Write-Host '========================================' -ForegroundColor DarkCyan
    Write-Host '  1 - Apply Singleplayer (49 mods)'
    Write-Host '  2 - Apply Multiplayer  (47 mods)'
    Write-Host '  3 - Show current profile and checks'
    Write-Host '  4 - Restore a previous backup'
    Write-Host '  0 - Exit'
    $Choice = (Read-Host 'Select').Trim()
    switch ($Choice) {
        '1' { Invoke-Safe { Apply-Profile 'SP' } }
        '2' { Invoke-Safe { Apply-Profile 'MP' } }
        '3' { Invoke-Safe { Show-Status } }
        '4' { Invoke-Safe { Restore-Backup } }
        '0' { exit 0 }
        default { Write-Host 'Invalid selection.' -ForegroundColor Yellow }
    }
}
