# Installs REFramework (stable v1.5.9.1, MHRISE build) into the game folder.
#   .\tools\install-reframework.ps1        -> Phase 0: dinput8.dll only (no VR)
#   .\tools\install-reframework.ps1 -VR    -> Phase 1: also openxr_loader.dll (OpenXR / VDXR)
# openvr_api.dll is never installed: its absence makes REFramework use OpenXR.
param([switch]$VR)
$ErrorActionPreference = "Stop"
. "$PSScriptRoot\common.ps1"
Assert-GameNotRunning

Write-Host "Installing REFramework into $GameDir"
Install-GameFile (Join-Path $VendorDir "dinput8.dll") "dinput8.dll"
Install-GameFile (Join-Path $VendorDir "reframework_revision.txt") "reframework_revision.txt"
if ($VR) {
    Install-GameFile (Join-Path $VendorDir "openxr_loader.dll") "openxr_loader.dll"
}
if (Test-Path (Join-Path $GameDir "openvr_api.dll")) {
    Write-Warning "openvr_api.dll is present in the game folder; REFramework will use OpenVR instead of OpenXR."
}
Write-Host "Done."
