@echo off
setlocal
if "%~1"=="" (
  echo Usage: hmodel ^<ollama-model^> [path]
  echo Example: hmodel "aikid123/Qwen3-coder:latest"
  echo Example: hmodel "fredrezones55/Jan-code:Q4_K_M"
  echo Example: hmodel "fredrezones55/qwen3.5-opus:4b" D:\projects\my-app
  echo Tip: run hmodels for recommended Hermes models
  exit /b 1
)
set "HERMES_MODEL=%~1"
if "%~2"=="" (
  set "TARGET_DIR=%cd%"
) else (
  set "TARGET_DIR=%~2"
)
for /f "usebackq delims=" %%I in (`wsl -d kali-linux -- wslpath "%TARGET_DIR%"`) do set "WSL_CWD=%%I"
if not defined WSL_CWD set "WSL_CWD=~"
if /I "%HERMES_MODEL%"=="aikid123/Qwen3-coder:latest" goto :recommended
if /I "%HERMES_MODEL%"=="fredrezones55/Jan-code:Q4_K_M" goto :recommended
if /I "%HERMES_MODEL%"=="fredrezones55/qwen3.5-opus:4b" goto :usable
if /I "%HERMES_MODEL%"=="relational/orlex:latest" goto :backup
if /I "%HERMES_MODEL%"=="rardiolata/CodeTito:latest" goto :experimental
if /I "%HERMES_MODEL%"=="codegemma:2b" goto :autocomplete
if /I "%HERMES_MODEL%"=="nomic-embed-text:latest" goto :wrongtype
echo [hmodel] Warning: %HERMES_MODEL% is unclassified in your local profile list.
echo [hmodel] It may chat fine but fail on Hermes tool use.
echo [hmodel] If you are testing CRUD/file tasks, prefer hjan, hqcoder, or hopus.
goto :launch

:recommended
echo [hmodel] Using recommended Hermes model: %HERMES_MODEL%
goto :launch

:usable
echo [hmodel] Using usable model: %HERMES_MODEL%
echo [hmodel] Good for heavier mixed work, but not as reliable as hjan or hqcoder.
goto :launch

:backup
echo [hmodel] Using backup Hermes model: %HERMES_MODEL%
echo [hmodel] Keep it as a reserve option unless it clearly outperforms your main stack.
goto :launch

:wrongtype
echo [hmodel] Warning: %HERMES_MODEL% is an embedding model, not a coding chat model.
echo [hmodel] Use hjan, horlex, or hopus for interactive agent work.
goto :launch

:autocomplete
echo [hmodel] Warning: %HERMES_MODEL% is better suited for autocomplete or insert-style workflows.
echo [hmodel] It is not a strong default for full agent chat and CRUD tasks.
goto :launch

:launch
wsl -d kali-linux -- bash -lc "export PATH=\"$HOME/.local/bin:/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin\"; export OPENAI_BASE_URL=\"http://host.docker.internal:11434/v1\"; export OPENAI_API_KEY=ollama; export LLM_MODEL=\"%HERMES_MODEL%\"; cd \"$WSL_CWD\" 2>/dev/null || cd ~; hermes chat -m \"%HERMES_MODEL%\""
