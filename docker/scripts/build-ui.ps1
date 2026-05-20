$ErrorActionPreference = 'Stop'

$Project = if ($args[0]) { $args[0] } else { 'demo' }
$ScriptDir = $PSScriptRoot
$DockerDir = Split-Path $ScriptDir -Parent
$RepoRoot  = Split-Path $DockerDir -Parent
$UiDir     = Join-Path (Split-Path $RepoRoot -Parent) "gaisoft-ui"

$DistSrc = Join-Path $UiDir "dist"
$HtmlDst = Join-Path $DockerDir "gaisoft\nginx\html"

if (-not (Test-Path $DistSrc)) {
    Write-Host "Error: dist not found at $DistSrc"
    Write-Host "Build first: cd $UiDir; npm run build:prod"
    exit 1
}

# Remove all contents except .gitkeep
Get-ChildItem $HtmlDst -Recurse -File | Where-Object { $_.Name -ne '.gitkeep' } | Remove-Item -Force
Get-ChildItem $HtmlDst -Directory | Remove-Item -Recurse -Force
Copy-Item "$DistSrc\*" $HtmlDst -Recurse -Force
Write-Host "✓ html updated from dist"

Push-Location $DockerDir
try {
    & docker compose --env-file "$DockerDir\.env" --env-file "projects\$Project\.env" exec gaisoft-frontend nginx -s reload
    if ($LASTEXITCODE -ne 0) { exit $LASTEXITCODE }
} finally {
    Pop-Location
}

Write-Host "✓ nginx reloaded"
