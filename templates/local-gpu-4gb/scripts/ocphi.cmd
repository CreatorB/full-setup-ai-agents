@echo off
setlocal
set "OLLAMA_KEEP_ALIVE=0"
set "OPENCLAW_LOCAL_AUTO_SWAP=true"
set "MINIMAX_API_KEY=your-minimax-api-key-here"
echo [ocphi] OpenClaw + MiniMax-M2.7 (primary) / Phi4-mini (fallback)
openclaw chat --model "minimax/MiniMax-M2.7"
