
param([string]$output = "")

if ($output -eq "")
{
  Write-Host "Usage: publish.ps1 <destination directory>"
  exit 1  
}

Write-Host "Publishing to directory '$($output)'"

# Write-Host "Getting the latest submodules (and deleting all local changes to submodules)"
# git submodule foreach git reset --hard
# git submodule update --recursive --remote

Write-Host "Building zoom-explorer"

Set-Location "zoom-explorer"

npx tsc
robocopy .\public .\dist

Set-Location ".."

New-Item -Force -Path "$($output)" -Name "zoom-explorer" -ItemType Directory

Write-Host "Copying files to directory '$($output)'"

robocopy /s . ..\website\ /xd ".git" /xd ".vscode" /xd "nodemodules" /xd "zoom-explorer" /xf ".git" /xf ".gitignore" /xf ".gitmodules" /xf "*.sh" /xf "*.ps1"
robocopy /s .\zoom-explorer\dist ..\website\zoom-explorer /xd ".git" /xd ".vscode" /xd "nodemodules" /xf ".git" /xf ".gitignore" /xf ".gitmodules" /xf "*.sh" /xf "*.ps1"

Write-Host "Done copying files to directory '$($output)'"
Write-Host "Patching html files for navigation bar"

(Get-Content -path 'midimonitor/index.html' -Raw) -replace '<!-- For www.waveformer.net', '' -replace '-->', '' | Set-Content -path "$($output)/midimonitor/index.html"
(Get-Content -path 'circuitbender/index.html' -Raw) -replace '<!-- For www.waveformer.net', '' -replace '-->', '' | Set-Content -path "$($output)/circuitbender/index.html"
(Get-Content -path 'zoom-explorer/dist/index.html' -Raw) -replace '<!-- For www.waveformer.net', '' -replace '-->', '' | Set-Content -path "$($output)/zoom-explorer/index.html"

Write-Host "Done patching html files for navigation bar"
Write-Host "Publishing to directory '$($output)' completed"

