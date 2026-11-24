$ErrorActionPreference = 'Stop'
. (Join-Path $PSScriptRoot 'Enter-Environment.ps1')
$projectRoot = Split-Path -Parent $PSScriptRoot
if (-not (Get-Command code -ErrorAction SilentlyContinue)) {
    throw 'VS Code CLI not found. Open this project folder from VS Code manually.'
}
& code --new-window $projectRoot
if ($LASTEXITCODE -ne 0) { throw 'Failed to open VS Code.' }
