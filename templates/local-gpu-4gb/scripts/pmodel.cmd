@echo off
setlocal
if "%~1"=="" (
  echo Usage: pmodel ^<ollama-model^> [path]
  echo Example: pmodel "fredrezones55/Jan-code:Q4_K_M"
  echo Example: pmodel "aikid123/Qwen3-coder:latest"
  echo Example: pmodel "novaforgeai/qwen2.5:3b-optimized"
  echo Example: pmodel relational/orlex:latest D:\projects\my-app
  echo Tip: run pmodels for recommended Pi models
  exit /b 1
)
set "PI_MODEL=%~1"
if "%~2"=="" (
  set "TARGET_DIR=%cd%"
) else (
  set "TARGET_DIR=%~2"
)
if /I "%PI_MODEL%"=="aikid123/Qwen3-coder:latest" goto :recommended
if /I "%PI_MODEL%"=="fredrezones55/Jan-code:Q4_K_M" goto :recommended
if /I "%PI_MODEL%"=="fredrezones55/qwen3.5-opus:4b" goto :usable
if /I "%PI_MODEL%"=="relational/orlex:latest" goto :backup
if /I "%PI_MODEL%"=="rardiolata/CodeTito:latest" goto :experimental
if /I "%PI_MODEL%"=="codegemma:2b" goto :autocomplete
if /I "%PI_MODEL%"=="novaforgeai/qwen2.5:3b-optimized" goto :experimental
if /I "%PI_MODEL%"=="nomic-embed-text:latest" goto :wrongtype
echo [pmodel] Warning: %PI_MODEL% is unclassified in your local Pi model list.
echo [pmodel] It may work, but verify file and tool behavior carefully.
goto :launch

:recommended
echo [pmodel] Using recommended Pi model: %PI_MODEL%
goto :launch

:usable
echo [pmodel] Using usable Pi model: %PI_MODEL%
echo [pmodel] Good for heavier mixed work, but not as safe as pijan or pqcoder.
goto :launch

:backup
echo [pmodel] Using backup Pi model: %PI_MODEL%
echo [pmodel] Keep it as a reserve option unless it clearly outperforms your main stack.
goto :launch

:experimental
echo [pmodel] Warning: %PI_MODEL% is experimental in Pi agent workflows.
echo [pmodel] Treat it as a test model until CRUD and tool behavior are verified.
goto :launch

:autocomplete
echo [pmodel] Warning: %PI_MODEL% is better suited for autocomplete or insert-style workflows.
echo [pmodel] It is not a strong default for full agent chat and CRUD tasks.
goto :launch

:wrongtype
echo [pmodel] Warning: %PI_MODEL% is an embedding model, not a coding chat model.
echo [pmodel] Use pijan, piorlex, or piopus for agent work.

:launch
pushd "%TARGET_DIR%" >nul 2>&1 || exit /b 1
pi --model "%PI_MODEL%"
