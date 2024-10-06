function la {
    param (
        [switch]$a,
        [switch]$l,
        [switch]$i,
        [switch]$d,
        [switch]$f,
        [switch]$info
    )

    if ($info) {
        Write-Host "Arguments information for 'la' function:" -ForegroundColor Yellow
        Write-Host "-a     : Shows all files, including hidden ones." -ForegroundColor Green
        Write-Host "-l     : Lists all files and directories in a column view." -ForegroundColor Green
        Write-Host "-i     : Displays file/directory name, creation date, and size, aligned in columns." -ForegroundColor Green
        Write-Host "-d     : Shows only directories." -ForegroundColor Green
        Write-Host "-f     : Shows only files." -ForegroundColor Green
        Write-Host "-info  : Displays information about available arguments." -ForegroundColor Green
        return
    }

    $items = Get-ChildItem -Force:$a

    if ($d) {
        $items = $items | Where-Object { $_.PSIsContainer }
    }
    elseif ($f) {
        $items = $items | Where-Object { -not $_.PSIsContainer }
    }

    $dirColor = [ConsoleColor]::DarkYellow
    $fileColor = [ConsoleColor]::Cyan
    $hiddenColor = [ConsoleColor]::DarkGray

    if ($i) {
        $nameWidth = 40
        $dateWidth = 20
        $sizeWidth = 10

        Write-Host ("Name".PadRight($nameWidth) + "Creation Date".PadRight($dateWidth) + "Size (KB)".PadRight($sizeWidth)) -ForegroundColor White
        Write-Host ("-" * ($nameWidth + $dateWidth + $sizeWidth)) -ForegroundColor White

        foreach ($item in $items) {
            $color = if ($item.Attributes -match "Hidden") { $hiddenColor }
                     elseif ($item.PSIsContainer) { $dirColor }
                     else { $fileColor }

            $name = $item.Name.PadRight($nameWidth)
            $creationDate = $item.CreationTime.ToString("yyyy-MM-dd HH:mm").PadRight($dateWidth)
            $size = if ($item.PSIsContainer) { "-" } else { '{0:N2}' -f ($item.Length / 1KB) }
            $size = $size.PadLeft($sizeWidth)

            Write-Host ("$name$creationDate$size") -ForegroundColor $color
        }
    }
    else {
        foreach ($item in $items) {
            if ($item.Attributes -match "Hidden") {
                $color = $hiddenColor
            }
            elseif ($item.PSIsContainer) {
                $color = $dirColor
            }
            else {
                $color = $fileColor
            }

            if ($l) {
                Write-Host $item.Name -ForegroundColor $color
            }
            else {
                Write-Host -NoNewline "$($item.Name)   " -ForegroundColor $color
            }
        }

        if (-not $l) {
            Write-Host
        }
    }
}
