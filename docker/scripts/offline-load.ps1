$ErrorActionPreference = 'Stop'

$ScriptDir = $PSScriptRoot
$DockerDir = Split-Path $ScriptDir -Parent
$ImagesDir = Join-Path $DockerDir "images"

$TarFiles = Get-ChildItem $ImagesDir -Filter "*.tar" -ErrorAction SilentlyContinue
if (-not $TarFiles) {
    Write-Host "Error: no .tar files found in $ImagesDir"
    Write-Host "Copy offline image tarballs to docker\images\ first"
    exit 1
}

foreach ($Tar in $TarFiles) {
    Write-Host "Loading $($Tar.Name) ..."
    & docker load -i $Tar.FullName
    if ($LASTEXITCODE -ne 0) { exit $LASTEXITCODE }
}

Write-Host ""
Write-Host "✓ All images loaded"
Write-Host "Now run: .\scripts\start.ps1 <project>"
