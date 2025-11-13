$ErrorActionPreference = 'Stop'

$moduleName = 'LaLs'

# Путь к модулю (как в chocolateyinstall.ps1)
$installPath = Join-Path $env:ProgramFiles "WindowsPowerShell\Modules\$moduleName"

if (Test-Path $installPath) {
    Write-Host "Removing PowerShell module path: $installPath" -ForegroundColor Yellow
    try {
        Remove-Item -Path $installPath -Recurse -Force
    } catch {
        Write-Warning "Failed to remove $installPath: $($_.Exception.Message)"
    }
} else {
    Write-Host "Module path not found (nothing to remove): $installPath" -ForegroundColor DarkGray
}

# Чистим настройки модуля в реестре (UseIconsPreference и т.п.)
$regPath = 'HKCU:\Software\LaLs'
if (Test-Path $regPath) {
    Write-Host "Removing registry key: $regPath" -ForegroundColor Yellow
    try {
        Remove-Item -Path $regPath -Recurse -Force
    } catch {
        Write-Warning "Failed to remove $regPath: $($_.Exception.Message)"
    }
}

# Удаляем переменную окружения, которую создаём в install-скрипте
try {
    [Environment]::SetEnvironmentVariable('LaLsModulePath', $null, 'Machine')
    [Environment]::SetEnvironmentVariable('LaLsModulePath', $null, 'User')
    Write-Host "Environment variable 'LaLsModulePath' removed (Machine/User)." -ForegroundColor Yellow
} catch {
    Write-Warning "Failed to remove environment variable 'LaLsModulePath': $($_.Exception.Message)"
}

Write-Host "LaLs uninstall script finished." -ForegroundColor Green
