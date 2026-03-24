@echo off
setlocal
echo Pi model recommendations for your machine:
echo.
echo [Recommended]
echo   pijan   - fredrezones55/Jan-code:Q4_K_M - best daily coding default
echo   pqcoder - aikid123/Qwen3-coder:latest   - fast code and thinking chat
echo   pidev   - task alias for daily coding
echo   pplan   - task alias for complex thinking and code
echo.
echo [Usable]
echo   piopus  - fredrezones55/qwen3.5-opus:4b - mixed heavier work
echo   pheavy  - task alias for heavier fallback
echo.
echo [Backup]
echo   piorlex - relational/orlex:latest       - backup reasoning/planning model
echo   ptito   - rardiolata/CodeTito:latest    - backup coding model
echo.
echo [Autocomplete]
echo   codegemma:2b                            - best used in editor autocomplete tools
echo.
echo [Experimental / Limited]
echo   novaforgeai/qwen2.5:3b-optimized        - small local CPU-friendly candidate, verify tools before trusting it
echo.
echo [Avoid]
echo   nomic-embed-text:latest                 - embedding model, not chat/coding
echo.
echo [Flexible]
echo   pmodel ^<model^>   - launch Pi with any configured local model
echo.
echo Configured Pi local models:
pi --list-models ollama
