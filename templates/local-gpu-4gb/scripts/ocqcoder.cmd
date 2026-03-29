@echo off
setlocal
set "OPENCLAW_MODEL=aikid123/Qwen3-coder:latest"
openclaw chat --model %OPENCLAW_MODEL% --cwd %CD%
