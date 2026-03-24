@echo off
setlocal
for /f "usebackq delims=" %%I in (`wsl -d kali-linux -- wslpath "%cd%"`) do set "WSL_CWD=%%I"
if not defined WSL_CWD set "WSL_CWD=~"
wsl -d kali-linux -- bash -lc "export PATH=\"$HOME/.local/bin:/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin\"; export OPENAI_BASE_URL=\"http://host.docker.internal:11434/v1\"; export OPENAI_API_KEY=ollama; export LLM_MODEL=\"aikid123/Qwen3-coder:latest\"; cd \"$WSL_CWD\" 2>/dev/null || cd ~; hermes chat -m \"aikid123/Qwen3-coder:latest\""
