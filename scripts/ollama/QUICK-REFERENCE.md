# Ollama Auto-Start - Quick Reference

## TL;DR

**Problem:** Ollama doesn't work after PC restart
**Solution:** Auto-start configured to kill hung processes and start fresh
**Status:** ✅ ENABLED

## One-Time Setup (Already Done)

```bash
cscript scripts\setup-ollama-startup.vbs
```

## What Happens Now

```
PC Restart → Login → Wait 10s → Kill old Ollama → Start fresh → Ready!
```

## Commands

| Task | Command |
|------|---------|
| **Manual restart** | `scripts\restart-ollama.bat` |
| **Check status** | `cscript scripts\verify-ollama-startup.vbs` |
| **Check if running** | `tasklist \| findstr ollama` |
| **Test connection** | `curl http://localhost:11434/api/version` |
| **Disable auto-start** | `cscript scripts\remove-ollama-startup.vbs` |
| **Re-enable** | `cscript scripts\setup-ollama-startup.vbs` |

## Troubleshooting

### "Connection error" in AI tools?

```bash
# 1. Check if Ollama is running
tasklist | findstr ollama

# 2. If not running, restart it
scripts\restart-ollama.bat

# 3. Test connection
curl http://localhost:11434/api/version
```

### Ollama not starting after reboot?

```bash
# 1. Verify auto-start
cscript scripts\verify-ollama-startup.vbs

# 2. Re-run setup if needed
cscript scripts\setup-ollama-startup.vbs

# 3. Restart PC to test
```

### Want to disable?

```bash
cscript scripts\remove-ollama-startup.vbs
```

## How It Works

1. **At Login:** Windows runs `start-ollama-clean.bat`
2. **Wait 10s:** Let Windows services initialize
3. **Kill Old:** Terminate any hung Ollama processes
4. **Start Fresh:** Launch new Ollama instance (minimized)
5. **Ready:** Ollama running and responsive

## Technical Info

- **Auto-start method:** Windows Registry (HKCU\Run)
- **Registry key:** `OllamaClean`
- **Startup delay:** 10 seconds
- **Process cleanup:** Automatic
- **Window state:** Minimized
- **Admin required:** No

## Files

| File | Purpose |
|------|---------|
| `restart-ollama.bat` | Manual restart (use when hung) |
| `start-ollama-clean.bat` | Auto-run script |
| `setup-ollama-startup.vbs` | Enable auto-start |
| `verify-ollama-startup.vbs` | Check configuration |
| `remove-ollama-startup.vbs` | Disable auto-start |

## That's It!

No more manual restarts after PC reboot. Everything is automatic.

For detailed docs, see [README.md](README.md)
