# FPS.ps1
$Affinity = [IntPtr]0xFFF0     # CPU 4 t/m 15 aan (disable 0-3, enable 4-15)
$TryRealTime = $true           # eerst RealTime proberen (fallback naar High)
$IntervalSec = 2
$LogPath = Join-Path $PSScriptRoot "FPS.log"

function Log($m) {
    $line = "[{0}] {1}" -f (Get-Date -Format "yyyy-MM-dd HH:mm:ss"), $m
    Add-Content -Path $LogPath -Value $line
    Write-Host $m
}

Log "Monitor started. Watching Wow.exe | Affinity=0xFFF0 (CPU 4-15) | TryRealTime=$TryRealTime | Interval=${IntervalSec}s"

$lastPid = 0
$wasRunning = $false

while ($true) {
    $p = Get-Process -Name Wow -ErrorAction SilentlyContinue | Select-Object -First 1

    if (-not $p) {
        if ($wasRunning) {
            Log "World of Warcraft closed."
            $wasRunning = $false
            $lastPid = 0
        }
        Start-Sleep -Seconds $IntervalSec
        continue
    }

    if (-not $wasRunning) {
        Log "World of Warcraft started."
        $wasRunning = $true
    }

    if ($p.Id -ne $lastPid) {
        Log "WoW process changed. New PID: $($p.Id)"
        $lastPid = $p.Id
    }

    if ($p.ProcessorAffinity -ne $Affinity) {
        try {
            $p.ProcessorAffinity = $Affinity
            Log "Applied affinity (CPU 4-15)."
        } catch {
            Log "Failed to set affinity: $($_.Exception.Message)"
        }
    }

    try {
        if ($TryRealTime) {
            if ($p.PriorityClass -ne 'RealTime') {
                try {
                    $p.PriorityClass = 'RealTime'
                    Start-Sleep -Milliseconds 200
                    if ($p.PriorityClass -eq 'RealTime') {
                        Log "Priority set to RealTime."
                    } else {
                        throw "RealTime not accepted"
                    }
                } catch {
                    try {
                        $p.PriorityClass = 'High'
                        Log "RealTime failed -> fallback to High."
                    } catch {
                        Log "Failed to set priority: $($_.Exception.Message)"
                    }
                }
            }
        } else {
            if ($p.PriorityClass -ne 'High') {
                $p.PriorityClass = 'High'
                Log "Priority set to High."
            }
        }
    } catch {
        Log "Priority check failed: $($_.Exception.Message)"
    }

    Start-Sleep -Seconds $IntervalSec
}
