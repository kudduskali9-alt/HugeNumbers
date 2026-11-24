param([switch]$GetCache)
$ErrorActionPreference = 'Stop'
. (Join-Path $PSScriptRoot 'Enter-Environment.ps1')
$projectRoot = Split-Path -Parent $PSScriptRoot
Push-Location $projectRoot
try {
    $env:MATHLIB_CACHE_DIR = Join-Path $projectRoot '.lake/cache'
    & lean --version
    if ($LASTEXITCODE -ne 0) { throw 'Lean version check failed.' }
    & lake --version
    if ($LASTEXITCODE -ne 0) { throw 'Lake version check failed.' }
    if ($GetCache) {
        & lake exe cache get Mathlib.Computability.DFA
        if ($LASTEXITCODE -ne 0) { throw 'Cache download failed.' }
    }
    & lake build
    if ($LASTEXITCODE -ne 0) { throw 'Project build failed.' }
    & lake env lean Checks/Smoke.lean | Tee-Object -Variable smokeOutput
    if ($LASTEXITCODE -ne 0) { throw 'Smoke check failed.' }
    if (($smokeOutput -join "`n") -match '\bsorryAx\b') {
        throw 'Core theorem audit failed: sorryAx found.'
    }
    Write-Host 'PASS: project build and smoke check.'
} finally {
    Pop-Location
}
