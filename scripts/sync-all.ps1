$ErrorActionPreference = "Stop"

$repoRoot = Split-Path -Parent $PSScriptRoot
$workspaceRoot = Split-Path -Parent $repoRoot
$privateRepo = Join-Path $workspaceRoot "backup-full-setup-ai-agents"
$privateScript = Join-Path $privateRepo "scripts\sync-from-local.ps1"
$publicScript = Join-Path $repoRoot "scripts\refresh-public-templates.ps1"

if (-not (Test-Path $privateScript)) {
    throw "Private sync script not found: $privateScript"
}

if (-not (Test-Path $publicScript)) {
    throw "Public refresh script not found: $publicScript"
}

Write-Host "[1/2] Syncing local setup into private backup repo..."
& powershell -NoProfile -ExecutionPolicy Bypass -File $privateScript

Write-Host "[2/2] Refreshing public-safe templates from local setup..."
& powershell -NoProfile -ExecutionPolicy Bypass -File $publicScript

Write-Host "Done. Review both repositories and commit changes as needed."
