@echo off
setlocal
set "OPENCLAW_PROVIDER=ollama"
set "OPENCLAW_MODEL=fredrezones55/Jan-code:Q4_K_M"
set "OPENCLAW_PERSONALITY=%~dp0..\openclaw\personality.md"
openclaw chat --model %OPENCLAW_MODEL% --cwd %CD% --personality %OPENCLAW_PERSONALITY%
