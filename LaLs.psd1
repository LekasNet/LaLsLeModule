#
# Манифест модуля для модуля "PSGet_LaLs".
#
# Создано: lekas
#
# Дата создания: 07.10.2024
#

@{

# Файл модуля сценария или двоичного модуля, связанный с этим манифестом.
RootModule = 'LaLs.psm1'

# Номер версии данного модуля.
ModuleVersion = '1.0.0'

# Поддерживаемые выпуски PSEditions
# CompatiblePSEditions = @()

# Уникальный идентификатор данного модуля
GUID = 'aaeb3c92-3e49-4f54-96cc-13ddf0d67fdf'

# Автор данного модуля
Author = 'lekas'

# Компания, создавшая данный модуль, или его поставщик
CompanyName = 'LekasNoOne'

# Заявление об авторских правах на модуль
Copyright = '(c) 2024 lek4s. All rights reserved.'

# Описание функций данного модуля
Description = 'This module provides the `la` command for listing files and directories with color coding and formatting options.'

# Минимальный номер версии обработчика Windows PowerShell, необходимой для работы данного модуля
# PowerShellVersion = ''

# Имя узла Windows PowerShell, необходимого для работы данного модуля
# PowerShellHostName = ''

# Минимальный номер версии узла Windows PowerShell, необходимой для работы данного модуля
# PowerShellHostVersion = ''

# Минимальный номер версии Microsoft .NET Framework, необходимой для данного модуля. Это обязательное требование действительно только для выпуска PowerShell, предназначенного для компьютеров.
# DotNetFrameworkVersion = ''

# Минимальный номер версии среды CLR (общеязыковой среды выполнения), необходимой для работы данного модуля. Это обязательное требование действительно только для выпуска PowerShell, предназначенного для компьютеров.
# CLRVersion = ''

# Архитектура процессора (нет, X86, AMD64), необходимая для этого модуля
# ProcessorArchitecture = ''

# Модули, которые необходимо импортировать в глобальную среду перед импортированием данного модуля
# RequiredModules = @()

# Сборки, которые должны быть загружены перед импортированием данного модуля
# RequiredAssemblies = @()

# Файлы сценария (PS1), которые запускаются в среде вызывающей стороны перед импортом данного модуля.
# ScriptsToProcess = @()

# Файлы типа (.ps1xml), которые загружаются при импорте данного модуля
# TypesToProcess = @()

# Файлы формата (PS1XML-файлы), которые загружаются при импорте данного модуля
# FormatsToProcess = @()

# Модули для импорта в качестве вложенных модулей модуля, указанного в параметре RootModule/ModuleToProcess
# NestedModules = @()

# В целях обеспечения оптимальной производительности функции для экспорта из этого модуля не используют подстановочные знаки и не удаляют запись. Используйте пустой массив, если нет функций для экспорта.
FunctionsToExport = 'la'

# В целях обеспечения оптимальной производительности командлеты для экспорта из этого модуля не используют подстановочные знаки и не удаляют запись. Используйте пустой массив, если нет командлетов для экспорта.
CmdletsToExport = '*'

# Переменные для экспорта из данного модуля
VariablesToExport = '*'

# В целях обеспечения оптимальной производительности псевдонимы для экспорта из этого модуля не используют подстановочные знаки и не удаляют запись. Используйте пустой массив, если нет псевдонимов для экспорта.
AliasesToExport = '*'

# Ресурсы DSC для экспорта из этого модуля
# DscResourcesToExport = @()

# Список всех модулей, входящих в пакет данного модуля
# ModuleList = @()

# Список всех файлов, входящих в пакет данного модуля
# FileList = @()

# Личные данные для передачи в модуль, указанный в параметре RootModule/ModuleToProcess. Он также может содержать хэш-таблицу PSData с дополнительными метаданными модуля, которые используются в PowerShell.
PrivateData = @{

    PSData = @{

        # Tags applied to this module. These help with module discovery in online galleries.
        # Tags = @()

        # A URL to the license for this module.
        LicenseUri = 'https://opensource.org/licenses/MIT'

        # A URL to the main website for this project.
        ProjectUri = 'https://github.com/YourUsername/LaLs'

        # A URL to an icon representing this module.
        # IconUri = ''

        # ReleaseNotes of this module
        # ReleaseNotes = ''

        # Prerelease string of this module
        # Prerelease = ''

        # Flag to indicate whether the module requires explicit user acceptance for install/update/save
        RequireLicenseAcceptance = $true

        # External dependent modules of this module
        # ExternalModuleDependencies = @()

    } # End of PSData hashtable

 } # End of PrivateData hashtable

# Код URI для HelpInfo данного модуля
# HelpInfoURI = ''

# Префикс по умолчанию для команд, экспортированных из этого модуля. Переопределите префикс по умолчанию с помощью команды Import-Module -Prefix.
# DefaultCommandPrefix = ''

}

