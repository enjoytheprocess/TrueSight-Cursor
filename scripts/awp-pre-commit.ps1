# Git pre-commit: keep AWP register views in sync and run consistency checks.
# Install: pwsh scripts/install-hooks.ps1  (or make awp-install-hooks on Linux/WSL)
$ErrorActionPreference = 'Stop'

$Root = git rev-parse --show-toplevel
Set-Location $Root

function Invoke-AwpPreCommitWithMake {
    make awp-render
    if ($LASTEXITCODE -ne 0) { exit $LASTEXITCODE }

    git diff --quiet -- .awp-workspace/
    if ($LASTEXITCODE -ne 0) {
        Write-Error @"
pre-commit: generated .awp-workspace views are out of date.
  Run: make awp-render
  Then: git add .awp-workspace/
"@
        exit 1
    }

    make awp-docs-check
    exit $LASTEXITCODE
}

if (Get-Command make -ErrorAction SilentlyContinue) {
    Invoke-AwpPreCommitWithMake
}

if (Get-Command bash -ErrorAction SilentlyContinue) {
    bash scripts/awp-pre-commit
    exit $LASTEXITCODE
}

Write-Error @"
pre-commit: 'make' not found.

  WSL/Linux:  sudo apt install make
  Windows:    winget install GnuWin32.Make
              (or use WSL for the full AWP workflow — see README.md)
"@
exit 1
