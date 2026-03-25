@echo off
REM Ollama Clean Start Script
REM Auto-start Ollama with clean state after PC restart
REM Used by Windows startup registry to ensure Ollama runs properly

REM Delay 10 seconds to allow Windows startup services to initialize
timeout /t 10 /nobreak >nul

REM Kill any hung Ollama processes from previous session
taskkill /F /IM "ollama.exe" 2>nul
taskkill /F /IM "ollama app.exe" 2>nul

REM Wait for processes to terminate
timeout /t 2 /nobreak >nul

REM Start Ollama server in background (not the GUI app)
start /B "" "C:\Users\Alendia\AppData\Local\Programs\Ollama\ollama.exe" serve

REM Exit immediately
exit
