@echo off
setlocal
set "OLLAMA_KEEP_ALIVE=0"
echo [octool] Tool calling mode — Phi4-mini (local) with Nanbeige/Gemini fallback
echo   Use this for: shell commands, disk check, network ping, GitHub, email, skills
echo.
openclaw chat --model "ollama/phi4-mini:3.8b-q4_K_M"
