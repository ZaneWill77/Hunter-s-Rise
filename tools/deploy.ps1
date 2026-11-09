# Copies the mod's Lua scripts (mod\autorun\*) into the game's reframework\autorun\.
# All mod files are named hunters_rise* so uninstall.ps1 can find them.
# Lua scripts hot-reload: in the REFramework menu use ScriptRunner -> "Reset Scripts",
# so the game does not need to be closed for a script-only deploy.
$ErrorActionPreference = "Stop"
. "$PSScriptRoot\common.ps1"

$items = Get-ChildItem $ModSrc -ErrorAction SilentlyContinue
if (-not $items) { Write-Host "No mod scripts to deploy yet (mod\autorun is empty)."; return }

New-Item -ItemType Directory -Force $GameAutorun | Out-Null
foreach ($i in $items) {
    if ($i.Name -notlike "hunters_rise*") { Write-Warning "skipping $($i.Name): mod files must start with hunters_rise"; continue }
    Copy-Item $i.FullName $GameAutorun -Recurse -Force
    Write-Host "  deployed $($i.Name)"
}
Write-Host "Deployed. In game: Insert -> ScriptRunner -> Reset Scripts."
