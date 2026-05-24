# Verify .NET 9 SDK is available on Windows (install via official installer if missing).
$ErrorActionPreference = 'Stop'

if (Get-Command dotnet -ErrorAction SilentlyContinue) {
    $dotnetPath = (Get-Command dotnet).Source
    Write-Host "dotnet already on PATH: $dotnetPath"
    dotnet --version
    exit 0
}

Write-Host @"
.NET SDK not found on PATH.

Install .NET 9 SDK for Windows:
  https://dotnet.microsoft.com/download/dotnet/9.0

Or with winget:
  winget install Microsoft.DotNet.SDK.9

This project pins SDK 9.0.x (see global.json at the repo root).
Restart your terminal after installing.
"@ -ForegroundColor Yellow

exit 1
