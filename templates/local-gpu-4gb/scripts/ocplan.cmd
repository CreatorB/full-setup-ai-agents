@echo off
setlocal
set "OLLAMA_KEEP_ALIVE=0"
set "OPENCLAW_LOCAL_AUTO_SWAP=true"
echo [ocplan] Heavy reasoning mode — Qwen3.5-opus 4B
openclaw chat --model "ollama/fredrezones55/qwen3.5-opus:4b"
