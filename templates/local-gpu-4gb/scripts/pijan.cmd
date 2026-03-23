@echo off
setlocal
if "%~1"=="" (
  set "TARGET_DIR=%cd%"
) else (
  set "TARGET_DIR=%~1"
)
pushd "%TARGET_DIR%" >nul 2>&1 || exit /b 1
pi --model "fredrezones55/Jan-code:Q4_K_M"
