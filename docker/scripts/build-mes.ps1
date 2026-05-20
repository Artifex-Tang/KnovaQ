$ErrorActionPreference = 'Stop'

$Project = if ($args[0]) { $args[0] } else { 'demo' }
$ScriptDir  = $PSScriptRoot
$DockerDir  = Split-Path $ScriptDir -Parent
$RepoRoot   = Split-Path $DockerDir -Parent
$MesDir     = Join-Path (Split-Path $RepoRoot -Parent) "gaisoft-mes"

$JarSrc = Join-Path $MesDir "gaisoft-admin\target\gaisoftmes.jar"
$JarDst = Join-Path $DockerDir "gaisoft\jar\gaisoftmes.jar"

if (-not (Test-Path $JarSrc)) {
    Write-Host "Error: jar not found at $JarSrc"
    Write-Host "Build first: cd $MesDir; mvn clean package -pl gaisoft-admin -am -DskipTests"
    exit 1
}

Copy-Item $JarSrc $JarDst -Force
Write-Host "✓ Copied gaisoftmes.jar"

Push-Location $DockerDir
try {
    & docker compose --env-file "$DockerDir\.env" --env-file "projects\$Project\.env" restart gaisoft-server
    if ($LASTEXITCODE -ne 0) { exit $LASTEXITCODE }
} finally {
    Pop-Location
}

Write-Host "✓ gaisoft-server restarted"
