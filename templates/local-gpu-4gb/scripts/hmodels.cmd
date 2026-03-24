@echo off
setlocal
echo Hermes model recommendations for your machine:
echo.
echo [Recommended]
echo   hjan     - fredrezones55/Jan-code:Q4_K_M - best current Hermes default
echo   hqcoder  - aikid123/Qwen3-coder:latest   - fast code and thinking chat
echo   hcode    - aikid123/Qwen3-coder:latest   - compatibility alias
echo   hdev     - task alias for daily coding
echo   hplan    - task alias for complex thinking and code
echo.
echo [Usable]
echo   hopus    - fredrezones55/qwen3.5-opus:4b - mixed general usage
echo   hqwen    - fredrezones55/qwen3.5-opus:4b - compatibility alias
echo   hheavy   - task alias for heavier fallback
echo.
echo [Backup]
echo   horlex   - relational/orlex:latest       - backup reasoning/planning model
echo   htito    - rardiolata/CodeTito:latest    - backup coding model
echo.
echo [Autocomplete]
echo   codegemma:2b                             - best used in editor autocomplete tools
echo.
echo [Avoid]
echo   nomic-embed-text:latest                  - embedding model, not chat/coding
echo.
echo [Flexible]
echo   hmodel ^<model^>      - launch Hermes with any Ollama model
echo   hsetmodel ^<model^>   - make a model the persistent Hermes default
echo.
echo Installed Ollama models:
if exist "%LOCALAPPDATA%\Programs\Ollama\ollama.exe" (
  "%LOCALAPPDATA%\Programs\Ollama\ollama.exe" list
) else (
  echo Ollama executable not found at %LOCALAPPDATA%\Programs\Ollama\ollama.exe
)
