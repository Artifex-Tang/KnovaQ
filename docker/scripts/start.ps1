$ErrorActionPreference = 'Stop'

$ScriptDir = $PSScriptRoot
$DockerDir = Split-Path $ScriptDir -Parent
$Project   = $args[0]

Push-Location $DockerDir
try {
    if ($Project) {
        $ProjectDir = Join-Path $DockerDir "projects\$Project"
        if (-not (Test-Path $ProjectDir)) {
            Write-Host "Error: project '$Project' not found at $ProjectDir"
            exit 1
        }
        Copy-Item "$ProjectDir\nginx\default.conf" "$DockerDir\gaisoft\nginx\conf.d\default.conf" -Force
        Write-Host "✓ nginx config copied from projects/$Project/"
        & docker compose --env-file "$DockerDir\.env" --env-file "$ProjectDir\.env" up -d
        if ($LASTEXITCODE -ne 0) { exit $LASTEXITCODE }
        Write-Host "✓ KnovaQ started for project: $Project"
    } else {
        $DefaultConf = "$DockerDir\nginx\default.conf"
        if (Test-Path $DefaultConf) {
            Copy-Item $DefaultConf "$DockerDir\gaisoft\nginx\conf.d\default.conf" -Force
            Write-Host "✓ nginx config copied from docker\nginx\default.conf"
        }
        & docker compose --env-file "$DockerDir\.env" up -d
        if ($LASTEXITCODE -ne 0) { exit $LASTEXITCODE }
        Write-Host "✓ KnovaQ started"
    }
} finally {
    Pop-Location
}
