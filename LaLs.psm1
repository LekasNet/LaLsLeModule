function lz {
    [CmdletBinding()]
    param (
        # Базовые флаги
        [switch]$a,          # show all (hidden)
        [switch]$l,          # list (one per line)
        [switch]$i,          # info-table (date / size)
        [switch]$d,          # only directories
        [switch]$f,          # only files
        [switch]$m,          # modes (attributes)
        [switch]$info,       # help
        [Alias('structure')]
        [switch]$tree,       # tree view
        [switch]$git,        # git status

        # Новые фичи
        [ValidateSet('name','size','time','extension','length')]
        [string]$Sort = 'name',
        [switch]$Reverse,

        # Управление иконками
        [switch]$Icons,              # включить иконки только для этого вызова
        [string]$UseIconsPreference  # сохранить настройку в реестр: true/false/1/0/on/off
    )

    # ==========================
    # ВНУТРЕННИЕ ХЕЛПЕРЫ
    # ==========================

    function Get-LaLang {
        $candidates = @()

        if ($PSUICulture) { $candidates += $PSUICulture }
        if ($PSCulture)   { $candidates += $PSCulture }

        try {
            $ui = Get-UICulture
            if ($ui) { $candidates += $ui.Name }
        } catch {}

        try {
            $c = Get-Culture
            if ($c) { $candidates += $c.Name }
        } catch {}

        if ($env:LC_ALL) { $candidates += $env:LC_ALL }
        if ($env:LANG)   { $candidates += $env:LANG }

        foreach ($cand in $candidates) {
            if (-not $cand) { continue }
            $lang2 = $cand.Substring(0,2).ToLowerInvariant()
            switch ($lang2) {
                'ru' { return 'ru' }
                'en' { return 'en' }
                'de' { return 'de' }
            }
        }

        return 'en'
    }

    function Show-Help {
        param([string]$Lang)

        switch ($Lang) {
            'ru' {
                Write-Host "la — расширенный ls для PowerShell" -ForegroundColor Yellow
                Write-Host ""

                Write-Host "Базовые флаги:" -ForegroundColor Cyan
                Write-Host "  -a           Показывать все файлы, включая скрытые." -ForegroundColor Green
                Write-Host "  -l           Вывод по одному элементу в строке (long view)." -ForegroundColor Green
                Write-Host "  -i           Табличный вывод: имя, дата изменения, размер (человекочитаемый)." -ForegroundColor Green
                Write-Host "  -d           Только директории." -ForegroundColor Green
                Write-Host "  -f           Только файлы." -ForegroundColor Green
                Write-Host "  -m           Таблица атрибутов (ReadOnly, Hidden, System, Archive)." -ForegroundColor Green
                Write-Host ""

                Write-Host "Расширенный функционал:" -ForegroundColor Cyan
                Write-Host "  -tree        Дерево текущей директории (с иконками). Алиас: -structure" -ForegroundColor Green
                Write-Host "  -git         Git статус (короткий формат, раскрашенный по статусу)." -ForegroundColor Green
                Write-Host ""

                Write-Host "Иконки:" -ForegroundColor Cyan
                Write-Host "  -Icons                   Включить иконки только для этого вызова." -ForegroundColor Green
                Write-Host "  -UseIconsPreference true/false  Записать настройку в реестр (HKCU:\Software\LaLs)." -ForegroundColor Green
                Write-Host ""

                Write-Host "Сортировки:" -ForegroundColor Cyan
                Write-Host "  -Sort name       Сортировать по имени (по умолчанию)." -ForegroundColor Green
                Write-Host "  -Sort size       Сортировать по размеру." -ForegroundColor Green
                Write-Host "  -Sort time       Сортировать по времени изменения." -ForegroundColor Green
                Write-Host "  -Sort extension  Сортировать по расширению." -ForegroundColor Green
                Write-Host "  -Sort length     Сортировать по длине имени." -ForegroundColor Green
                Write-Host "  -Reverse         Реверсировать порядок сортировки." -ForegroundColor Green
                Write-Host ""

                Write-Host "Примеры:" -ForegroundColor Cyan
                Write-Host "  la                          # базовый цветной список" -ForegroundColor White
                Write-Host "  la -a                       # показать скрытые" -ForegroundColor White
                Write-Host "  la -i                       # таблица: имя + дата + размер" -ForegroundColor White
                Write-Host "  la -d -Sort name            # только директории, по имени" -ForegroundColor White
                Write-Host "  la -f -Sort size -Reverse   # файлы по размеру по убыванию" -ForegroundColor White
                Write-Host "  la -tree                    # дерево текущей папки" -ForegroundColor White
                Write-Host "  la -git                     # git статус" -ForegroundColor White
                Write-Host "  la -Icons                   # добавить иконки только сейчас" -ForegroundColor White
                Write-Host "  la -UseIconsPreference true # включить иконки навсегда" -ForegroundColor White
                Write-Host "  la -UseIconsPreference false# отключить иконки навсегда" -ForegroundColor White
            }

            'en' {
                Write-Host "la — advanced ls-like command for PowerShell" -ForegroundColor Yellow
                Write-Host ""

                Write-Host "Basic flags:" -ForegroundColor Cyan
                Write-Host "  -a           Show hidden files." -ForegroundColor Green
                Write-Host "  -l           One item per line (long view)." -ForegroundColor Green
                Write-Host "  -i           Table view: name, modified date, human-readable size." -ForegroundColor Green
                Write-Host "  -d           Directories only." -ForegroundColor Green
                Write-Host "  -f           Files only." -ForegroundColor Green
                Write-Host "  -m           Attribute table (ReadOnly, Hidden, System, Archive)." -ForegroundColor Green
                Write-Host ""

                Write-Host "Extended features:" -ForegroundColor Cyan
                Write-Host "  -tree        Directory tree (with icons). Alias: -structure" -ForegroundColor Green
                Write-Host "  -git         Git status (short, colored by status)." -ForegroundColor Green
                Write-Host ""

                Write-Host "Icons:" -ForegroundColor Cyan
                Write-Host "  -Icons                   Enable icons for this call only." -ForegroundColor Green
                Write-Host "  -UseIconsPreference true/false  Persist icons setting in registry (HKCU:\Software\LaLs)." -ForegroundColor Green
                Write-Host ""

                Write-Host "Sorting:" -ForegroundColor Cyan
                Write-Host "  -Sort name       Sort by name (default)." -ForegroundColor Green
                Write-Host "  -Sort size       Sort by size." -ForegroundColor Green
                Write-Host "  -Sort time       Sort by modification time." -ForegroundColor Green
                Write-Host "  -Sort extension  Sort by extension." -ForegroundColor Green
                Write-Host "  -Sort length     Sort by name length." -ForegroundColor Green
                Write-Host "  -Reverse         Reverse sorting order." -ForegroundColor Green
                Write-Host ""

                Write-Host "Examples:" -ForegroundColor Cyan
                Write-Host "  la                          # basic colored list" -ForegroundColor White
                Write-Host "  la -a                       # show hidden" -ForegroundColor White
                Write-Host "  la -i                       # table: name + date + size" -ForegroundColor White
                Write-Host "  la -d -Sort name            # directories only, sorted by name" -ForegroundColor White
                Write-Host "  la -f -Sort size -Reverse   # files sorted by size, descending" -ForegroundColor White
                Write-Host "  la -tree                    # tree of current directory" -ForegroundColor White
                Write-Host "  la -git                     # git status" -ForegroundColor White
                Write-Host "  la -Icons                   # enable icons for this run" -ForegroundColor White
                Write-Host "  la -UseIconsPreference true # turn icons on permanently" -ForegroundColor White
                Write-Host "  la -UseIconsPreference false# turn icons off permanently" -ForegroundColor White
            }

            'de' {
                Write-Host "la — erweiterter ls-ähnlicher Befehl für PowerShell" -ForegroundColor Yellow
                Write-Host ""

                Write-Host "Basis-Flags:" -ForegroundColor Cyan
                Write-Host "  -a           Versteckte Dateien anzeigen." -ForegroundColor Green
                Write-Host "  -l           Ein Element pro Zeile (Long View)." -ForegroundColor Green
                Write-Host "  -i           Tabellenansicht: Name, Datum, Größe (lesbar)." -ForegroundColor Green
                Write-Host "  -d           Nur Verzeichnisse." -ForegroundColor Green
                Write-Host "  -f           Nur Dateien." -ForegroundColor Green
                Write-Host "  -m           Attribut-Tabelle (ReadOnly, Hidden, System, Archive)." -ForegroundColor Green
                Write-Host ""

                Write-Host "Erweiterte Funktionen:" -ForegroundColor Cyan
                Write-Host "  -tree        Verzeichnisbaum (mit Icons). Alias: -structure" -ForegroundColor Green
                Write-Host "  -git         Git-Status (kurz, farbig nach Status)." -ForegroundColor Green
                Write-Host ""

                Write-Host "Icons:" -ForegroundColor Cyan
                Write-Host "  -Icons                   Icons nur für diesen Aufruf aktivieren." -ForegroundColor Green
                Write-Host "  -UseIconsPreference true/false  Einstellung dauerhaft in der Registry speichern (HKCU:\Software\LaLs)." -ForegroundColor Green
                Write-Host ""

                Write-Host "Sortierung:" -ForegroundColor Cyan
                Write-Host "  -Sort name       Nach Name sortieren (Standard)." -ForegroundColor Green
                Write-Host "  -Sort size       Nach Größe sortieren." -ForegroundColor Green
                Write-Host "  -Sort time       Nach Änderungsdatum sortieren." -ForegroundColor Green
                Write-Host "  -Sort extension  Nach Erweiterung sortieren." -ForegroundColor Green
                Write-Host "  -Sort length     Nach Namenslänge sortieren." -ForegroundColor Green
                Write-Host "  -Reverse         Reihenfolge umkehren." -ForegroundColor Green
                Write-Host ""

                Write-Host "Beispiele:" -ForegroundColor Cyan
                Write-Host "  la                          # Standardliste mit Farben" -ForegroundColor White
                Write-Host "  la -a                       # versteckte Dateien anzeigen" -ForegroundColor White
                Write-Host "  la -i                       # Tabelle: Name + Datum + Größe" -ForegroundColor White
                Write-Host "  la -d -Sort name            # nur Verzeichnisse, nach Name sortiert" -ForegroundColor White
                Write-Host "  la -f -Sort size -Reverse   # Dateien nach Größe absteigend" -ForegroundColor White
                Write-Host "  la -tree                    # Verzeichnisbaum" -ForegroundColor White
                Write-Host "  la -git                     # Git-Status" -ForegroundColor White
                Write-Host "  la -Icons                   # Icons nur für diesen Aufruf" -ForegroundColor White
                Write-Host "  la -UseIconsPreference true # Icons dauerhaft aktivieren" -ForegroundColor White
                Write-Host "  la -UseIconsPreference false# Icons dauerhaft deaktivieren" -ForegroundColor White
            }

            default {
                Show-Help -Lang 'en'
            }
        }
    }

    function Get-LaIconsConfig {
        $path = 'HKCU:\Software\LaLs'
        $useIcons = $true  # дефолт: иконки включены

        if (Test-Path $path) {
            try {
                $props = Get-ItemProperty -Path $path -Name 'UseIcons' -ErrorAction SilentlyContinue
                if ($null -ne $props.UseIcons) {
                    $useIcons = [bool]$props.UseIcons
                }
            } catch {}
        }

        return $useIcons
    }

    function Set-LaIconsConfig {
        param([bool]$Value)

        $path = 'HKCU:\Software\LaLs'
        if (-not (Test-Path $path)) {
            New-Item -Path $path -Force | Out-Null
        }
        New-ItemProperty -Path $path -Name 'UseIcons' -Value ([int]$Value) -PropertyType DWord -Force | Out-Null
    }

    function Get-ItemIcon {
        param(
            [Parameter(Mandatory)]
            [System.IO.FileSystemInfo]$Item,
            [bool]$UseIcons
        )

        if (-not $UseIcons) {
            return ""
        }

        if ($Item.PSIsContainer) {
            return "📁"
        }

        switch -Regex ($Item.Extension.ToLower()) {
            '\.psm1|\.ps1'                 { return "⚙️" }
            '\.psd1'                       { return "📦" }
            '\.nupkg|\.zip|\.7z|\.rar'     { return "📦" }
            '\.txt|\.log'                  { return "📝" }
            '\.md'                         { return "📓" }
            '\.png|\.jpg|\.jpeg|\.gif|\.svg|\.webp' { return "🖼️" }
            '\.json|\.xml|\.yml|\.yaml'    { return "📄" }
            '\.exe|\.bat|\.cmd'            { return "🚀" }
            default                        { return "📄" }
        }
    }

    function Write-ItemName {
        param(
            [Parameter(Mandatory)]
            [System.IO.FileSystemInfo]$Item,
            [System.ConsoleColor]$DirColor,
            [System.ConsoleColor]$FileColor,
            [System.ConsoleColor]$HiddenColor,
            [bool]$UseIcons,
            [switch]$Long
        )

        if ($Item.Attributes -band [IO.FileAttributes]::Hidden) {
            $color = $HiddenColor
        }
        elseif ($Item.PSIsContainer) {
            $color = $DirColor
        }
        else {
            $color = $FileColor
        }

        $icon = Get-ItemIcon -Item $Item -UseIcons:$UseIcons
        $text = if ($UseIcons -and $icon) { "$icon $($Item.Name)" } else { $Item.Name }

        if ($Long) {
            Write-Host $text -ForegroundColor $color
        }
        else {
            Write-Host -NoNewline "$text   " -ForegroundColor $color
        }
    }

    function Show-Modes {
        param(
            [System.IO.FileSystemInfo[]]$Items,
            [System.ConsoleColor]$DirColor,
            [System.ConsoleColor]$FileColor,
            [System.ConsoleColor]$HiddenColor,
            [bool]$UseIcons
        )

        $nameWidth = 40
        $modeWidth = 30

        Write-Host ("Name".PadRight($nameWidth) + "Mode".PadRight($modeWidth)) -ForegroundColor White
        Write-Host ("-" * ($nameWidth + $modeWidth)) -ForegroundColor White

        foreach ($item in $Items) {
            if ($item.Attributes -band [IO.FileAttributes]::Hidden) {
                $color = $HiddenColor
            }
            elseif ($item.PSIsContainer) {
                $color = $DirColor
            }
            else {
                $color = $FileColor
            }

            $icon = Get-ItemIcon -Item $item -UseIcons:$UseIcons
            $nameText = if ($UseIcons -and $icon) { "$icon $($item.Name)" } else { $item.Name }
            $name = $nameText.PadRight($nameWidth)

            $modeParts = @()

            if ($item.Attributes -band [IO.FileAttributes]::ReadOnly) { $modeParts += "Read-Only" }
            else { $modeParts += "Read/Write" }

            if ($item.Attributes -band [IO.FileAttributes]::Directory) { $modeParts += "Directory" }
            if ($item.Attributes -band [IO.FileAttributes]::Archive)   { $modeParts += "Archive" }
            if ($item.Attributes -band [IO.FileAttributes]::System)    { $modeParts += "System" }
            if ($item.Attributes -band [IO.FileAttributes]::Hidden)    { $modeParts += "Hidden" }

            $mode = ($modeParts -join ", ")

            Write-Host ($name + $mode) -ForegroundColor $color
        }
    }

    function Format-SizeHuman {
        param(
            [long]$Bytes
        )

        if ($Bytes -lt 1KB) { return "$Bytes B" }
        elseif ($Bytes -lt 1MB) { return ("{0:N2} KB" -f ($Bytes / 1KB)) }
        elseif ($Bytes -lt 1GB) { return ("{0:N2} MB" -f ($Bytes / 1MB)) }
        elseif ($Bytes -lt 1TB) { return ("{0:N2} GB" -f ($Bytes / 1GB)) }
        else { return ("{0:N2} TB" -f ($Bytes / 1TB)) }
    }

    function Show-InfoTable {
        param(
            [System.IO.FileSystemInfo[]]$Items,
            [System.ConsoleColor]$DirColor,
            [System.ConsoleColor]$FileColor,
            [System.ConsoleColor]$HiddenColor,
            [bool]$UseIcons
        )

        $nameWidth = 40
        $dateWidth = 20
        $sizeWidth = 14

        Write-Host ("Name".PadRight($nameWidth) + "Modified".PadRight($dateWidth) + "Size".PadLeft($sizeWidth)) -ForegroundColor White
        Write-Host ("-" * ($nameWidth + $dateWidth + $sizeWidth)) -ForegroundColor White

        foreach ($item in $Items) {
            if ($item.Attributes -band [IO.FileAttributes]::Hidden) {
                $color = $HiddenColor
            }
            elseif ($item.PSIsContainer) {
                $color = $DirColor
            }
            else {
                $color = $FileColor
            }

            $icon = Get-ItemIcon -Item $item -UseIcons:$UseIcons
            $nameText = if ($UseIcons -and $icon) { "$icon $($item.Name)" } else { $item.Name }
            $name         = $nameText.PadRight($nameWidth)
            $modDate      = $item.LastWriteTime.ToString("yyyy-MM-dd HH:mm").PadRight($dateWidth)
            $size =
                if ($item.PSIsContainer) {
                    "-"
                }
                else {
                    Format-SizeHuman -Bytes $item.Length
                }

            $size = $size.PadLeft($sizeWidth)

            Write-Host ("$name$modDate$size") -ForegroundColor $color
        }
    }

    function Show-TreeInternal {
        param(
            [string]$Path,
            [string]$Prefix,
            [int]$Depth,
            [int]$MaxDepth,
            [bool]$ShowHidden,
            [System.ConsoleColor]$DirColor,
            [System.ConsoleColor]$FileColor,
            [System.ConsoleColor]$HiddenColor,
            [bool]$UseIcons
        )

        if ($Depth -ge $MaxDepth) { return }

        $items = Get-ChildItem -LiteralPath $Path -Force:$ShowHidden |
                 Sort-Object { -not $_.PSIsContainer }, Name

        $count = $items.Count
        for ($i = 0; $i -lt $count; $i++) {
            $item   = $items[$i]
            $isLast = ($i -eq $count - 1)

            $connector   = if ($isLast) { "└── " } else { "├── " }
            $childPrefix = if ($isLast) { "$Prefix    " } else { "$Prefix│   " }

            if ($item.Attributes -band [IO.FileAttributes]::Hidden) {
                $color = $HiddenColor
            }
            elseif ($item.PSIsContainer) {
                $color = $DirColor
            }
            else {
                $color = $FileColor
            }

            $icon = Get-ItemIcon -Item $item -UseIcons:$UseIcons
            $text = if ($UseIcons -and $icon) { "$icon $($item.Name)" } else { $item.Name }

            Write-Host ($Prefix + $connector + $text) -ForegroundColor $color

            if ($item.PSIsContainer) {
                Show-TreeInternal -Path $item.FullName -Prefix $childPrefix -Depth ($Depth + 1) -MaxDepth $MaxDepth -ShowHidden:$ShowHidden -DirColor $DirColor -FileColor $FileColor -HiddenColor $HiddenColor -UseIcons:$UseIcons
            }
        }
    }

    function Show-Tree {
        param(
            [string]$RootPath,
            [bool]$ShowHidden,
            [int]$MaxDepth,
            [System.ConsoleColor]$DirColor,
            [System.ConsoleColor]$FileColor,
            [System.ConsoleColor]$HiddenColor,
            [bool]$UseIcons
        )

        $root = Get-Item -LiteralPath $RootPath

        $icon = Get-ItemIcon -Item $root -UseIcons:$UseIcons
        $rootText = if ($UseIcons -and $icon) { "$icon $($root.FullName)" } else { $root.FullName }

        Write-Host $rootText -ForegroundColor Yellow
        Show-TreeInternal -Path $root.FullName -Prefix "" -Depth 0 -MaxDepth $MaxDepth -ShowHidden:$ShowHidden -DirColor $DirColor -FileColor $FileColor -HiddenColor $HiddenColor -UseIcons:$UseIcons
    }

    # ==========================
    # НАСТРОЙКА ИКОНОК
    # ==========================

    $useIconsEffective = Get-LaIconsConfig
    if ($PSBoundParameters.ContainsKey('UseIconsPreference')) {
        $val = $UseIconsPreference
        if ($null -eq $val) {
            $val = ""
        }
        $val = $val.ToLowerInvariant()

        $bool =
            if ($val -in @('1','true','yes','on')) { $true }
            elseif ($val -in @('0','false','no','off')) { $false }
            else { $null }

        if ($null -eq $bool) {
            Write-Host "Invalid value for -UseIconsPreference. Use: true/false/1/0/on/off." -ForegroundColor Red
            return
        }

        Set-LaIconsConfig -Value $bool
        $useIconsEffective = $bool
    }


    if ($Icons) {
        $useIconsEffective = $true
    }

    # ==========================
    # ОСНОВНАЯ ЛОГИКА
    # ==========================

    # Git режим
    if ($git) {
        if (-not (Test-Path ".git")) {
            Write-Host "This directory is not a Git repository." -ForegroundColor Red
            return
        }

        $gitStatus = git status --porcelain

        foreach ($line in $gitStatus) {
            if (-not $line) { continue }

            $statusCode = $line.Substring(0, 2).Trim()
            $fileName   = $line.Substring(3)

            switch ($statusCode) {
                "M"  { Write-Host $fileName -ForegroundColor Cyan }    # modified
                "A"  { Write-Host $fileName -ForegroundColor Green }   # added
                "D"  { Write-Host $fileName -ForegroundColor Red }     # deleted
                "??" { Write-Host $fileName -ForegroundColor Yellow }  # untracked
                default { Write-Host $fileName -ForegroundColor White }
            }
        }

        return
    }

    # Дерево (-tree / -structure)
    if ($tree) {
        $dirColor    = [System.ConsoleColor]::DarkYellow
        $fileColor   = [System.ConsoleColor]::Cyan
        $hiddenColor = [System.ConsoleColor]::DarkGray

        $rootPath = (Get-Location).Path
        Show-Tree -RootPath $rootPath -ShowHidden:([bool]$a) -MaxDepth 10 -DirColor $dirColor -FileColor $fileColor -HiddenColor $hiddenColor -UseIcons:$useIconsEffective
        return
    }

    # Справка
    if ($info) {
        $lang = Get-LaLang
        Show-Help -Lang $lang
        return
    }

    # Базовый список
    $items = Get-ChildItem -Force:$a

    if ($d) {
        $items = $items | Where-Object { $_.PSIsContainer }
    }
    elseif ($f) {
        $items = $items | Where-Object { -not $_.PSIsContainer }
    }

    # Сортировки
    switch ($Sort) {
        'name' {
            $items = $items | Sort-Object Name
        }
        'size' {
            $items = $items | Sort-Object { if ($_.PSIsContainer) { 0 } else { $_.Length } }
        }
        'time' {
            $items = $items | Sort-Object LastWriteTime
        }
        'extension' {
            $items = $items | Sort-Object Extension, Name
        }
        'length' {
            $items = $items | Sort-Object { $_.Name.Length }
        }
    }

    if ($Reverse) {
        $items = [System.Collections.ArrayList]::new($items)
        [void]$items.Reverse()
    }

    $dirColor    = [System.ConsoleColor]::DarkYellow
    $fileColor   = [System.ConsoleColor]::Cyan
    $hiddenColor = [System.ConsoleColor]::DarkGray

    if ($m) {
        Show-Modes -Items $items -DirColor $dirColor -FileColor $fileColor -HiddenColor $hiddenColor -UseIcons:$useIconsEffective
    }
    elseif ($i) {
        Show-InfoTable -Items $items -DirColor $dirColor -FileColor $fileColor -HiddenColor $hiddenColor -UseIcons:$useIconsEffective
    }
    else {
        foreach ($item in $items) {
            Write-ItemName -Item $item -DirColor $dirColor -FileColor $fileColor -HiddenColor $hiddenColor -UseIcons:$useIconsEffective -Long:$l
        }

        if (-not $l) {
            Write-Host
        }
    }
}
