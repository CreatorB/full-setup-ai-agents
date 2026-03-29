@echo off
setlocal
set "OLLAMA_KEEP_ALIVE=0"
set "OPENCLAW_LOCAL_AUTO_SWAP=true"
echo [ocislami] Islamic assistant mode — skills: daily-planner, notif-monitor
openclaw chat --skills daily-planner,notif-monitor --model "ollama/fredrezones55/Jan-code:Q4_K_M"
