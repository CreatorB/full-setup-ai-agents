@echo off
REM Ollama Restart Script
REM Cleanly restarts Ollama by killing existing processes and starting fresh
REM Solves issues with hung Ollama processes after PC restart

echo ========================================
echo Restarting Ollama Service
echo ========================================

REM Stop all running Ollama processes
echo Stopping all Ollama processes...
taskkill /F /IM "ollama.exe" 2>nul
taskkill /F /IM "ollama app.exe" 2>nul

REM Wait for processes to terminate
timeout /t 2 /nobreak >nul

REM Check if any Ollama processes are still running
tasklist | findstr /i "ollama" >nul
if %errorlevel% equ 0 (
    echo Warning: Some Ollama processes may still be running
    timeout /t 3 /nobreak >nul
)

REM Start fresh Ollama server
echo Starting Ollama server...
start /B "" "C:\Users\Alendia\AppData\Local\Programs\Ollama\ollama.exe" serve

REM Wait for Ollama to initialize
echo Waiting for Ollama to be ready...
timeout /t 10 /nobreak >nul

REM Test Ollama API
echo Testing Ollama connection...
curl -s http://localhost:11434/api/version
if %errorlevel% equ 0 (
    echo.
    echo ========================================
    echo Ollama restarted successfully!
    echo ========================================
    echo.
    echo You can now run: ollama list
) else (
    echo.
    echo ========================================
    echo ERROR: Ollama server not responding
    echo ========================================
    echo Check if port 11434 is blocked
)

echo.
pause
