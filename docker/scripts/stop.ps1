$ErrorActionPreference = 'Stop'

$ScriptDir = $PSScriptRoot
$DockerDir = Split-Path $ScriptDir -Parent

Push-Location $DockerDir
try {
    & docker compose down
    if ($LASTEXITCODE -ne 0) { exit $LASTEXITCODE }
} finally {
    Pop-Location
}

Write-Host "✓ KnovaQ stopped"
