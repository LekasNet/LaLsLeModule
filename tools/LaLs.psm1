function la {
    param (
        [switch]$a,
        [switch]$l,
        [switch]$i,
        [switch]$d,
        [switch]$f,
        [switch]$m,
        [switch]$info,
        [switch]$structure,
	[switch]$git
    )

    if ($git) {
        if (-not (Test-Path ".git")) {
            Write-Host "This directory is not a Git repository." -ForegroundColor Red
            return
        }

        $gitStatus = git status --porcelain

        foreach ($line in $gitStatus) {
            $statusCode = $line.Substring(0, 2).Trim()
            $fileName = $line.Substring(3)

            switch ($statusCode) {
                "M" { Write-Host $fileName -ForegroundColor Cyan }    
                "A" { Write-Host $fileName -ForegroundColor Green }   
                "D" { Write-Host $fileName -ForegroundColor Red }     
                "??" { Write-Host $fileName -ForegroundColor Yellow } 
                default { Write-Host $fileName -ForegroundColor White } 
            }
        }

        return
    }

    if ($structure) {
        if (-not (Test-Path $PROFILE)) {
            Write-Error "Profile not found: $PROFILE"
            return
        }

        $profileDir = Split-Path $PROFILE

        if (-not $profileDir) {
            Write-Error "Profile directory is not available."
            return
        }

	$pythonScript = Join-Path $profileDir "Scripts\print_directory_structure.py"

        $projectPath = Get-Location

        python $pythonScript $projectPath

        return
    }

    if ($info) {
        Write-Host "Arguments information for 'la' function:" -ForegroundColor Yellow
        Write-Host "-a     : Shows all files, including hidden ones." -ForegroundColor Green
        Write-Host "-l     : Lists all files and directories in a column view." -ForegroundColor Green
        Write-Host "-i     : Displays file/directory name, creation date, and size, aligned in columns." -ForegroundColor Green
        Write-Host "-d     : Shows only directories." -ForegroundColor Green
        Write-Host "-f     : Shows only files." -ForegroundColor Green
        Write-Host "-m     : Lists files with their access modes (read, write, execute)." -ForegroundColor Green
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

    if ($m) {
        $nameWidth = 40
        $modeWidth = 15

        Write-Host ("Name".PadRight($nameWidth) + "Mode".PadRight($modeWidth)) -ForegroundColor White
        Write-Host ("-" * ($nameWidth + $modeWidth)) -ForegroundColor White

        foreach ($item in $items) {
            $color = if ($item.Attributes -match "Hidden") { $hiddenColor }
                     elseif ($item.PSIsContainer) { $dirColor }
                     else { $fileColor }

            $name = $item.Name.PadRight($nameWidth)

            $mode = ""
            if ($item.Attributes -match "ReadOnly") { $mode += "Read-Only" }
            else { $mode += "Read/Write" }

            if ($item.Attributes -match "Directory") { $mode += ", Directory" }
            if ($item.Attributes -match "Archive") { $mode += ", Archive" }
            if ($item.Attributes -match "System") { $mode += ", System" }
            if ($item.Attributes -match "Hidden") { $mode += ", Hidden" }

            Write-Host ("$name$mode") -ForegroundColor $color
        }
    }
    elseif ($i) {
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
