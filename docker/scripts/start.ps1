$ErrorActionPreference = 'Stop'

$ScriptDir = $PSScriptRoot
$DockerDir = Split-Path $ScriptDir -Parent

$Project = if ($args[0]) { $args[0] } else { 'demo' }

$ProjectDir = Join-Path $DockerDir "projects\$Project"

if (-not (Test-Path $ProjectDir)) {
    Write-Host "Error: project '$Project' not found at $ProjectDir"
    exit 1
}

Copy-Item "$ProjectDir\nginx\default.conf" "$DockerDir\gaisoft\nginx\conf.d\default.conf" -Force
Write-Host "✓ nginx config copied from projects/$Project/"

Push-Location $DockerDir
try {
    & docker compose --env-file "$DockerDir\.env" --env-file "$ProjectDir\.env" up -d
    if ($LASTEXITCODE -ne 0) { exit $LASTEXITCODE }
} finally {
    Pop-Location
}

Write-Host "✓ KnovaQ started for project: $Project"
