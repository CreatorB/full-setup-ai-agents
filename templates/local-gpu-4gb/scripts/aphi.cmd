@echo off
setlocal
echo [aphi] Aider + Phi4-mini (reasoning, --raw-model --edit-format whole)
aider --raw-model --edit-format whole --model "ollama_chat/phi4-mini:3.8b-q4_K_M" %*
