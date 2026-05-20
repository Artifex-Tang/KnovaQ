$ErrorActionPreference = 'Stop'

$ScriptDir  = $PSScriptRoot
$DockerDir  = Split-Path $ScriptDir -Parent
$ImagesDir  = Join-Path $DockerDir "images"

New-Item -ItemType Directory -Force $ImagesDir | Out-Null

Push-Location $DockerDir
try {
    $Images = & docker compose config --images 2>$null
    if ($LASTEXITCODE -ne 0 -or -not $Images) {
        Write-Host "Error: could not read images from docker-compose.yml"
        exit 1
    }

    foreach ($Image in $Images) {
        $Filename = ($Image -replace '[/:]', '_') + '.tar'
        Write-Host "Saving $Image -> images/$Filename"
        & docker save $Image -o (Join-Path $ImagesDir $Filename)
        if ($LASTEXITCODE -ne 0) { exit $LASTEXITCODE }
    }
} finally {
    Pop-Location
}

$TotalBytes = (Get-ChildItem $ImagesDir -Recurse -File | Measure-Object -Property Length -Sum).Sum
$TotalGB = [math]::Round($TotalBytes / 1GB, 2)

Write-Host ""
Write-Host "✓ All images saved to docker\images\"
Write-Host "  Total size: $TotalGB GB"
Write-Host ""
Write-Host "Next: Compress-Archive -Path docker -DestinationPath knovaq-offline.zip"
