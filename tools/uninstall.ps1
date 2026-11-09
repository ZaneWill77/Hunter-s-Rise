# Removes REFramework and the mod from the game folder, returning it to vanilla.
#   .\tools\uninstall.ps1         -> remove DLLs and mod scripts, keep reframework\ (settings, logs)
#   .\tools\uninstall.ps1 -All    -> also delete the reframework\ folder and REFramework log
param([switch]$All)
$ErrorActionPreference = "Stop"
. "$PSScriptRoot\common.ps1"
Assert-GameNotRunning

foreach ($f in "dinput8.dll", "openxr_loader.dll", "openvr_api.dll", "reframework_revision.txt") {
    $p = Join-Path $GameDir $f
    if (Test-Path $p) { Remove-Item $p -Confirm:$false; Write-Host "  removed $f" }
}
Get-ChildItem $GameAutorun -Filter "hunters_rise*" -ErrorAction SilentlyContinue |
    ForEach-Object { Remove-Item $_.FullName -Recurse -Confirm:$false; Write-Host "  removed autorun\$($_.Name)" }

if ($All) {
    foreach ($p in (Join-Path $GameDir "reframework"), (Join-Path $GameDir "re2_framework_log.txt"), (Join-Path $GameDir "re2_framework_config.txt")) {
        if (Test-Path $p) { Remove-Item $p -Recurse -Confirm:$false; Write-Host "  removed $p" }
    }
}
Write-Host "Game folder is back to vanilla (plus any backups listed in .\backups)."
