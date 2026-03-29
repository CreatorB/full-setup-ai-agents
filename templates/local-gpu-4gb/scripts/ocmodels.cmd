@echo off
echo OpenClaw model recommendations for your machine:
echo.
echo [Recommended]
echo   ocdev     - fredrezones55/Jan-code:Q4_K_M - best current OpenClaw default
echo   ocqcoder  - aikid123/Qwen3-coder:latest   - fast code and thinking chat
echo   octito    - rardiolata/CodeTito:latest    - backup coding model
echo.
echo [Flexible]
echo   ocmodel ^<model^>      - launch OpenClaw with any Ollama model
echo.
echo Installed Ollama models:
if exist "%LOCALAPPDATA%\Programs\Ollama\ollama.exe" (
  "%LOCALAPPDATA%\Programs\Ollama\ollama.exe" list
) else (
  echo Ollama executable not found at %LOCALAPPDATA%\Programs\Ollama\ollama.exe
)
