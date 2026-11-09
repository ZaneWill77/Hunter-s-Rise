# Shared paths for Hunter's Rise tooling. Dot-source this file: . "$PSScriptRoot\common.ps1"

$ProjectRoot = Split-Path -Parent $PSScriptRoot
$GameDir     = "C:\Program Files (x86)\Steam\steamapps\common\MonsterHunterRise"
$VendorDir   = Join-Path $ProjectRoot "vendor\stable-1.5.9.1\extracted"
$BackupRoot  = Join-Path $ProjectRoot "backups"
$ModSrc      = Join-Path $ProjectRoot "mod\autorun"
$GameAutorun = Join-Path $GameDir "reframework\autorun"

if (-not (Test-Path (Join-Path $GameDir "MonsterHunterRise.exe"))) {
    throw "Game not found at $GameDir"
}

function Assert-GameNotRunning {
    if (Get-Process -Name "MonsterHunterRise" -ErrorAction SilentlyContinue) {
        throw "Monster Hunter Rise is running. Close it first."
    }
}

# Copy a file into the game folder, backing up anything it would overwrite.
function Install-GameFile([string]$Source, [string]$RelativeDest) {
    $dest = Join-Path $GameDir $RelativeDest
    if (Test-Path $dest) {
        $stamp  = Get-Date -Format "yyyyMMdd-HHmmss"
        $backup = Join-Path $BackupRoot "$stamp\$RelativeDest"
        New-Item -ItemType Directory -Force (Split-Path -Parent $backup) | Out-Null
        Copy-Item $dest $backup
        Write-Host "  backed up existing $RelativeDest -> $backup"
    }
    New-Item -ItemType Directory -Force (Split-Path -Parent $dest) | Out-Null
    Copy-Item $Source $dest -Force
    Write-Host "  installed $RelativeDest"
}
