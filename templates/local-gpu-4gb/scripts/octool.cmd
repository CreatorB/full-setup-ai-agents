@echo off
setlocal
set "OLLAMA_KEEP_ALIVE=0"
echo [octool] Tool calling mode — Nanbeige4.1 (local) with Gemini Flash fallback
echo   Use this for: shell commands, disk check, network ping, GitHub, email, skills
echo.
openclaw chat --model "ollama/softw8/Nanbeige4.1-3B-q4_K_M:latest"
