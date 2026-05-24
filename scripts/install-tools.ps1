# Install yq (required for AWP render/docs-check) on Windows.
$ErrorActionPreference = 'Stop'

$YqInstallDir = if ($env:YQ_INSTALL_DIR) { $env:YQ_INSTALL_DIR } else { Join-Path $env:LOCALAPPDATA 'Programs\yq' }
$arch = if ([Environment]::Is64BitOperatingSystem) { 'amd64' } else { '386' }
$url = "https://github.com/mikefarah/yq/releases/latest/download/yq_windows_${arch}.exe"
$dest = Join-Path $YqInstallDir 'yq.exe'

Write-Host "Downloading yq (windows/$arch) from latest release..."
New-Item -ItemType Directory -Path $YqInstallDir -Force | Out-Null
Invoke-WebRequest -Uri $url -OutFile $dest -UseBasicParsing

$version = & $dest --version 2>&1
if ($version -notmatch 'version v[4-9]') {
    Write-Error "Downloaded binary does not look like yq v4+. Check $dest manually."
    exit 1
}

Write-Host "Installed: $version"
Write-Host "Location:  $dest"

$userPath = [Environment]::GetEnvironmentVariable('Path', 'User')
$pathEntries = $userPath -split ';' | Where-Object { $_ -ne '' }
if ($pathEntries -notcontains $YqInstallDir) {
    Write-Host ""
    Write-Host "NOTE: $YqInstallDir is not in your user PATH."
    Write-Host "Add it in System Settings, or run:"
    Write-Host "  [Environment]::SetEnvironmentVariable('Path', `"$userPath;$YqInstallDir`", 'User')"
}

Write-Host ""
Write-Host "Checking for Graphviz (dot)..."
if (Get-Command dot -ErrorAction SilentlyContinue) {
    Write-Host "Graphviz already installed: $(dot -V 2>&1)"
    exit 0
}

Write-Host "Graphviz not found. Install with:"
Write-Host "  winget install Graphviz.Graphviz"
Write-Host "Or download from: https://graphviz.org/download/"
exit 0
