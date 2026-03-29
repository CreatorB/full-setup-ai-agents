@echo off
setlocal
set "OLLAMA_KEEP_ALIVE=0"
set "OPENCLAW_LOCAL_AUTO_SWAP=true"
echo [octeach] Teaching assistant mode — skills: teaching-material, student-grader, daily-planner
openclaw chat --skills teaching-material,student-grader,daily-planner --model "ollama/fredrezones55/Jan-code:Q4_K_M"
