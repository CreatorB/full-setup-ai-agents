@echo off
setlocal
echo Aider model recommendations for your machine:
echo.
echo [Recommended]
echo   ajan    - fredrezones55/Jan-code:Q4_K_M - best daily coding default
echo   acode   - Jan-code alias
echo   aqcoder - aikid123/Qwen3-coder:latest  - fast code and thinking chat
echo   adev    - task alias for daily coding
echo   aplan   - fredrezones55/qwen3.5-opus:4b - complex thinking and code
echo.
echo [Usable]
echo   aopus   - fredrezones55/qwen3.5-opus:4b - mixed heavier work
echo   agen    - Qwen3.5 Opus alias
echo   aheavy  - task alias for heavier fallback
echo.
echo [Backup]
echo   aorlex  - relational/orlex:latest       - backup reasoning/planning model
echo   atito   - rardiolata/CodeTito:latest    - backup coding model
echo.
echo [Autocomplete]
echo   codegemma:2b                            - best used in editor autocomplete tools
echo.
echo [Avoid]
echo   nomic-embed-text:latest                 - embedding model, not chat/coding
echo.
echo [Flexible]
echo   amodel ^<model^>    - launch Aider with any installed Ollama model
echo.
echo Installed Ollama models:
if exist "%LOCALAPPDATA%\Programs\Ollama\ollama.exe" (
  "%LOCALAPPDATA%\Programs\Ollama\ollama.exe" list
) else (
  echo Ollama executable not found at %LOCALAPPDATA%\Programs\Ollama\ollama.exe
)
