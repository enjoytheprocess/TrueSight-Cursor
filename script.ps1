
# PowerShell script to generate my-app project structure
# Run this script from the parent directory of your my-app folder, or modify the $baseDir variable
 
param(
    [string]$BaseDir = ".\Truesight-Cursor"
)
 
# Verify the base directory exists
if (-not (Test-Path $BaseDir)) {
    Write-Error "Base directory '$BaseDir' does not exist. Please create it first."
    exit 1
}
 
Write-Host "Generating project structure in: $BaseDir" -ForegroundColor Green
 
# Create all directories
$directories = @(
    ".cursor/rules",
    ".cursor/snippets",
    "docs/architecture",
    "docs/api",
    "docs/decisions",
    "backend/src/Api",
    "backend/src/Application",
    "backend/src/Infrastructure",
    "backend/src/Shared",
    "backend/tests/UnitTests",
    "backend/tests/IntegrationTests",
    "backend/tests/ArchitectureTests",
    "frontend/src/app",
    "frontend/src/features",
    "frontend/src/shared",
    "frontend/src/components",
    "frontend/src/hooks",
    "frontend/src/services",
    "frontend/src/routes",
    "frontend/public",
    "frontend/tests",
    "database/migrations",
    "database/seed",
    "database/schema",
    "scripts",
    "docker"
)
 
# Create all directories
foreach ($dir in $directories) {
    $fullPath = Join-Path $BaseDir $dir
    if (-not (Test-Path $fullPath)) {
        New-Item -ItemType Directory -Path $fullPath -Force | Out-Null
        Write-Host "Created: $dir" -ForegroundColor Cyan
    }
    else {
        Write-Host "Exists: $dir" -ForegroundColor Yellow
    }
}
 
# Create .cursor/rules files
$cursorRulesFiles = @(
    "architecture.mdc",
    "backend.mdc",
    "frontend.mdc",
    "database.mdc",
    "testing.mdc",
    "api-contracts.mdc"
)
 
foreach ($file in $cursorRulesFiles) {
    $filePath = Join-Path $BaseDir ".cursor/rules/$file"
    if (-not (Test-Path $filePath)) {
        New-Item -ItemType File -Path $filePath -Force | Out-Null
        Write-Host "Created: .cursor/rules/$file" -ForegroundColor Cyan
    }
}
 
# Create .cursor/snippets files
$snippetFiles = @(
    "feature-template.md",
    "endpoint-template.md"
)
 
foreach ($file in $snippetFiles) {
    $filePath = Join-Path $BaseDir ".cursor/snippets/$file"
    if (-not (Test-Path $filePath)) {
        New-Item -ItemType File -Path $filePath -Force | Out-Null
        Write-Host "Created: .cursor/snippets/$file" -ForegroundColor Cyan
    }
}
 
# Create docs files
$docsFiles = @(
    "docs/architecture/vertical-slices.md",
    "docs/architecture/cqrs.md",
    "docs/architecture/coding-standards.md"
)
 
foreach ($file in $docsFiles) {
    $filePath = Join-Path $BaseDir $file
    if (-not (Test-Path $filePath)) {
        New-Item -ItemType File -Path $filePath -Force | Out-Null
        Write-Host "Created: $file" -ForegroundColor Cyan
    }
}
 
# Create root level files
$rootFiles = @(
    ".editorconfig",
    ".gitignore",
    "README.md",
    "cursor.md",
    "docker-compose.yml"
)
 
foreach ($file in $rootFiles) {
    $filePath = Join-Path $BaseDir $file
    if (-not (Test-Path $filePath)) {
        New-Item -ItemType File -Path $filePath -Force | Out-Null
        Write-Host "Created: $file" -ForegroundColor Cyan
    }
}
 
# Create backend solution file
$solutionFile = Join-Path $BaseDir "backend/MyApp.sln"
if (-not (Test-Path $solutionFile)) {
    New-Item -ItemType File -Path $solutionFile -Force | Out-Null
    Write-Host "Created: backend/MyApp.sln" -ForegroundColor Cyan
}
 
Write-Host "`n✓ Project structure generated successfully!" -ForegroundColor Green
Write-Host "Location: $BaseDir" -ForegroundColor Green