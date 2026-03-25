# Troubleshooting

## Ollama Connection Errors

### "Connection error" in AI agents (Aider, Pi, etc.)

**Symptoms:**
- Error messages like "Connection error" when running AI tools
- Agent fails to connect to Ollama
- Works fine initially but fails after PC restart

**Solution:**

1. Check if Ollama is running:
   ```bash
   tasklist | findstr ollama
   ```

2. If not running or hung, restart manually:
   ```bash
   scripts\ollama\restart-ollama.bat
   ```

3. Test Ollama connection:
   ```bash
   curl http://localhost:11434/api/version
   ```

4. **Permanent fix:** Setup auto-start to prevent this issue after PC restarts:
   ```bash
   cscript scripts\ollama\setup-ollama-startup.vbs
   ```

See [scripts/ollama/README.md](../../scripts/ollama/README.md) for full documentation.

### Ollama hangs after PC restart

**Problem:** After every PC restart, Ollama processes are running but not responding.

**Solution:** Use the Ollama auto-start scripts which automatically kill hung processes and start fresh:

```bash
# One-time setup
cscript scripts\ollama\setup-ollama-startup.vbs

# Restart PC to test
```

What this does:
- Kills hung Ollama processes automatically
- Starts fresh instance with 10-second delay
- Runs minimized in background
- No admin privileges required

See [scripts/ollama/QUICK-REFERENCE.md](../../scripts/ollama/QUICK-REFERENCE.md) for quick commands.

## Ollama Model Not Found

- run `ollama list`
- confirm the model name matches the launcher or config exactly

## Windows PATH Issues

- reopen the terminal after updating PATH
- verify that `aider`, `pi`, and your launcher scripts are on PATH

## Hermes WSL Issues

- verify WSL is running
- verify Hermes can reach Windows Ollama through `host.docker.internal`

## Model Loads but Behaves Badly

- this is often a model-quality problem, not a launcher problem
- switch to the safer default first
- use task-specific aliases instead of forcing a weak model

## CRUD Tasks Stop Halfway

- this happens with some local models
- verify file state manually
- prefer the safest default model for important edits
