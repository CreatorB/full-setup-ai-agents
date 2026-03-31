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

## OpenClaw Gateway CPU Spikes

**Symptoms:**
- CPU occasionally spikes to 30-80% even when no AI inference is running
- Noticeable on work PCs with other active applications
- Happens even when no messages are being sent to the bot

**Cause:**

The OpenClaw gateway is a persistent Node.js process. The CPU spikes come from:
- **Telegram long-polling** — keeps a persistent connection to Telegram servers; reconnects every ~30 seconds when idle
- **Node.js event loop and GC** — background cycles from the always-running process
- **Context pruning timer** — if TTL is set too short (default was 30m), background checks run frequently

**Fix 1: Stop gateway when not needed**

```powershell
openclaw gateway stop
```

Restart when needed:

```powershell
openclaw gateway
```

**Fix 2: Increase contextPruning TTL**

In `~/.openclaw/openclaw.json`, set:

```json
"contextPruning": {
  "mode": "cache-ttl",
  "ttl": "120m"
}
```

This reduces background pruning cycles from every 30 minutes to every 120 minutes.

**Fix 3: Remove gateway auto-start**

If the gateway was installed as a Windows auto-start service and you prefer to start it manually:

```powershell
openclaw gateway uninstall
```

Then start manually: `openclaw gateway`

**Note:** Telegram long-polling CPU overhead cannot be fully eliminated while the gateway is running. It is inherent to how Telegram bots work. The options above reduce it but do not remove it entirely.

## OpenClaw Skills on Work PC

**Problem:** Skills like `himalaya` (email) and `github`/`gh-issues` (GitHub CLI) may appear as "ready" even when rarely used. On a work PC, having email credentials or GitHub auth accessible via an AI agent is a security risk.

**Solution: Remove unused CLI binaries**

```powershell
# Remove himalaya binary (disables email skill)
Remove-Item C:\Users\<username>\scripts\himalaya.exe -Force

# Remove himalaya config (contains email passwords)
Remove-Item ~\.config\himalaya\config.toml -Force

# Remove gh copy from scripts (if you have a copy there)
Remove-Item C:\Users\<username>\scripts\gh.exe -Force
```

After removing the binary, `openclaw skills list` will show `△ needs setup` instead of `✓ ready`.

**Note for gh CLI:** If `gh` is installed system-wide (via `choco install gh`), removing the scripts copy is not enough — OpenClaw will still detect it in `Program Files`. To fully disable GitHub skills, uninstall via Admin PowerShell:

```powershell
choco uninstall gh
```

Or leave it installed but be aware the GitHub skill remains active.
