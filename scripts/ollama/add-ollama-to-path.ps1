# Add Ollama to User PATH
Write-Host "========================================" -ForegroundColor Cyan
Write-Host "Add Ollama to PATH" -ForegroundColor Cyan
Write-Host "========================================" -ForegroundColor Cyan
Write-Host ""

$ollamaPath = "C:\Users\Alendia\AppData\Local\Programs\Ollama"

# Get current user PATH
$currentPath = [Environment]::GetEnvironmentVariable("Path", "User")

# Check if Ollama already in PATH
if ($currentPath -like "*$ollamaPath*") {
    Write-Host "Ollama is already in PATH" -ForegroundColor Green
    Write-Host ""
    Write-Host "Current PATH includes:" -ForegroundColor Yellow
    Write-Host "  $ollamaPath" -ForegroundColor White
} else {
    Write-Host "Adding Ollama to User PATH..." -ForegroundColor Yellow

    # Add to PATH
    $newPath = "$currentPath;$ollamaPath"
    [Environment]::SetEnvironmentVariable("Path", $newPath, "User")

    Write-Host "SUCCESS! Ollama added to PATH" -ForegroundColor Green
    Write-Host ""
    Write-Host "Added:" -ForegroundColor Yellow
    Write-Host "  $ollamaPath" -ForegroundColor White
    Write-Host ""
    Write-Host "IMPORTANT: Restart your terminal/PowerShell for changes to take effect" -ForegroundColor Yellow
}

Write-Host ""
Write-Host "After restarting terminal, you can use:" -ForegroundColor Cyan
Write-Host "  ollama list" -ForegroundColor White
Write-Host "  ollama ps" -ForegroundColor White
Write-Host "  ollama run <model>" -ForegroundColor White
Write-Host ""
