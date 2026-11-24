$ErrorActionPreference = 'Stop'

# Refresh the environment even when the terminal predates the installation.
$userElan = [Environment]::GetEnvironmentVariable('ELAN_HOME', 'User')
if ($userElan) { $env:ELAN_HOME = $userElan }
$userPathValue = [Environment]::GetEnvironmentVariable('Path', 'User')
$machinePathValue = [Environment]::GetEnvironmentVariable('Path', 'Machine')
$env:Path = "$userPathValue;$machinePathValue;$env:Path"
if ($env:ELAN_HOME) {
    $env:Path = (Join-Path $env:ELAN_HOME 'bin') + ';' + $env:Path
}

foreach ($tool in @('git', 'lean', 'lake')) {
    if (-not (Get-Command $tool -ErrorAction SilentlyContinue)) {
        throw "Missing tool: $tool. Install Git and elan, then reopen the terminal."
    }
}
