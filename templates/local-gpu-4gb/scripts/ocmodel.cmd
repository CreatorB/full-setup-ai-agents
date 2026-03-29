@echo off
setlocal
if "%~1"=="" (
  echo Usage: ocmodel ^<ollama-model^> [path]
  exit /b 1
)
set "OPENCLAW_MODEL=%~1"
if "%~2"=="" (
  set "TARGET_DIR=%cd%"
) else (
  set "TARGET_DIR=%~2"
)
openclaw chat --model %OPENCLAW_MODEL% --cwd %TARGET_DIR%
