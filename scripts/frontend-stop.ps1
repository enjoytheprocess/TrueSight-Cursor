# Stop the Vite dev server bound to the default frontend port (5173).
param(
    [int]$Port = $(if ($env:TRUESIGHT_WEB_PORT) { [int]$env:TRUESIGHT_WEB_PORT } else { 5173 })
)

$ErrorActionPreference = 'Stop'

$connections = @(Get-NetTCPConnection -LocalPort $Port -State Listen -ErrorAction SilentlyContinue)
if ($connections.Count -eq 0) {
    Write-Host "No process listening on port $Port."
    exit 0
}

$pids = $connections | Select-Object -ExpandProperty OwningProcess -Unique
foreach ($procId in $pids) {
    $proc = Get-Process -Id $procId -ErrorAction SilentlyContinue
    $name = if ($proc) { $proc.ProcessName } else { '?' }
    Write-Host "Stopping PID $procId ($name) on port $Port ..."
    Stop-Process -Id $procId -ErrorAction SilentlyContinue
}

Start-Sleep -Seconds 1
$stillListening = Get-NetTCPConnection -LocalPort $Port -State Listen -ErrorAction SilentlyContinue
if ($stillListening) {
    Write-Host "Port $Port still in use; forcing stop ..."
    foreach ($procId in $pids) {
        Stop-Process -Id $procId -Force -ErrorAction SilentlyContinue
    }
}

Write-Host "Port $Port is free."
