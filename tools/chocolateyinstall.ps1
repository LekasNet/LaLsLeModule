$ErrorActionPreference = 'Stop'
$toolsDir = "$(Split-Path -parent $MyInvocation.MyCommand.Definition)"
$modulePath = Join-Path $toolsDir 'LaLs.psm1'

if (-Not (Test-Path $modulePath)) {
    Write-Error "PowerShell module not found: $modulePath"
    exit 1
}

$installPath = Join-Path $env:ProgramFiles "WindowsPowerShell\Modules\LaLs"

if (Test-Path $installPath) {
    Remove-Item -Recurse -Force -Path $installPath
}

New-Item -ItemType Directory -Path $installPath
Copy-Item -Path $modulePath -Destination $installPath

$modulePathInEnvironment = Join-Path $installPath 'LaLs.psm1'
Install-ChocolateyEnvironmentVariable -variableName 'LaLsModulePath' -variableValue $modulePathInEnvironment

Import-Module $modulePathInEnvironment

Write-Host "PowerShell module LaLs installed successfully. Please contact me if you have any ideas to improve the package and increase its functionality."
