@echo off
setlocal
set "MINIMAX_API_KEY=your-minimax-api-key-here"
set "OPENCLAW_PROVIDER=minimax"
set "OPENCLAW_MODEL=MiniMax-M2.7"
set "OPENCLAW_PERSONALITY=%~dp0..\openclaw\personality.md"
echo [ocdev] OpenClaw + MiniMax-M2.7 (daily default)
openclaw chat --model %OPENCLAW_MODEL% --cwd %CD% --personality %OPENCLAW_PERSONALITY%
