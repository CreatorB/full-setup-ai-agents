@echo off
setlocal
set "OLLAMA_KEEP_ALIVE=0"
set "OPENCLAW_LOCAL_AUTO_SWAP=true"
echo [ocphi] OpenClaw + Phi4-mini (reasoning + tool calling)
openclaw chat --model "ollama/phi4-mini:3.8b-q4_K_M"
