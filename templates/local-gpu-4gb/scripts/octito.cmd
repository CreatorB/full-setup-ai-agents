@echo off
setlocal
set "OPENCLAW_MODEL=rardiolata/CodeTito:latest"
openclaw chat --model %OPENCLAW_MODEL% --cwd %CD%
