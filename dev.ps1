# dev.ps1 — перезагрузка dev-версии la из текущей папки

# Путь к этому скрипту
$here = Split-Path -Parent $MyInvocation.MyCommand.Path

# На всякий случай выпиливаем модуль LaLs, если он загружен
Remove-Module LaLs -ErrorAction SilentlyContinue

# И функцию la из текущей сессии, если уже есть
if (Get-Command la -ErrorAction SilentlyContinue) {
    Remove-Item Function:la -ErrorAction SilentlyContinue
}

# Dot-sourcing LaLs.psm1 из той же папки, где лежит dev.ps1
. (Join-Path $here 'LaLs.psm1')

Write-Host "Dev-версия 'la' загружена из $here" -ForegroundColor Green

# Для контроля — покажем, откуда теперь берётся la
Get-Command la | Select-Object Name, CommandType, Version, Source, `
    @{Name='File';Expression={$_.ScriptBlock.File}} | Format-List
