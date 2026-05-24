# Install the AWP git pre-commit hook (Windows / cross-platform).
$ErrorActionPreference = 'Stop'

$Root = git rev-parse --show-toplevel
$Hook = Join-Path $Root '.git/hooks/pre-commit'
$Dispatcher = Join-Path $Root 'scripts/git-pre-commit-hook'

if (Test-Path $Hook) {
    $existing = Get-Content $Hook -Raw
    if ($existing -notmatch 'awp-pre-commit') {
        Write-Error "ERROR: .git/hooks/pre-commit exists. Merge scripts/git-pre-commit-hook manually or remove the hook first."
        exit 1
    }
}

Copy-Item -Path $Dispatcher -Destination $Hook -Force
Write-Host "Installed .git/hooks/pre-commit (AWP render + docs-check)."
