# Ollama Auto-Start Fix

## Problem

After every PC restart, Ollama fails to run properly and requires manual intervention:
- Processes hang or become unresponsive
- Need to manually kill processes using Task Manager
- Must restart Ollama manually to restore functionality

## Solution

Automated startup configuration that ensures Ollama runs cleanly after every system restart by:
1. Killing any hung processes from previous sessions
2. Starting fresh Ollama instance with proper initialization
3. Running minimized in background with startup delay

## Features

- **Auto-start**: Ollama starts automatically 10 seconds after login
- **Clean restart**: Automatically terminates hung processes before starting
- **Background operation**: Runs minimized without visible windows
- **Stability**: Startup delay ensures Windows services are ready
- **No admin required**: Uses Windows registry (HKCU) for user-level startup

## Quick Start

### Step 1: Add Ollama to PATH (Required First)

Ollama must be in your PATH to work properly:

```powershell
# Run in PowerShell:
powershell -ExecutionPolicy Bypass -File scripts\add-ollama-to-path.ps1
```

**IMPORTANT: Restart your terminal/PowerShell after adding to PATH!**

### Step 2: Install Auto-Start

Run the setup script:

```bash
# Double-click or run from command prompt
cscript scripts\setup-ollama-startup.vbs
```

### Step 3: Verify Installation

Check auto-start status:

```bash
cscript scripts\verify-ollama-startup.vbs
```

### Step 4: Test

1. Restart your PC
2. Login and wait ~15 seconds
3. Verify Ollama is running:
   ```bash
   ollama list
   ```

## Scripts

### Core Scripts

| Script | Purpose | When to Use |
|--------|---------|-------------|
| `add-ollama-to-path.ps1` | Add Ollama to PATH | **Run this FIRST** (one-time setup) |
| `start-ollama-clean.bat` | Clean startup script | Auto-run at login (configured by setup) |
| `restart-ollama.bat` | Manual restart | When Ollama hangs or needs restart |
| `setup-ollama-startup.vbs` | Configure auto-start | Initial setup or re-enable after removal |
| `verify-ollama-startup.vbs` | Check configuration | Verify auto-start is configured |
| `remove-ollama-startup.vbs` | Disable auto-start | Remove from startup |

### Advanced Scripts (Optional)

| Script | Purpose | Requirements |
|--------|---------|--------------|
| `setup-ollama-startup.ps1` | Task Scheduler method | Admin privileges |
| `setup-ollama-startup-simple.bat` | Registry method (batch) | None |
| `remove-ollama-startup.bat` | Remove auto-start (batch) | None |

## How It Works

### Startup Sequence

```
Windows Login
    ↓
Wait 10 seconds (system stabilization)
    ↓
Kill hung Ollama processes
    ↓
Wait 2 seconds (cleanup)
    ↓
Start fresh Ollama instance (minimized)
    ↓
Ready!
```

### Technical Details

**Registry Location:**
```
HKCU\Software\Microsoft\Windows\CurrentVersion\Run\OllamaClean
```

**Registry Value:**
```
D:\IT\HSN\Developments\sources\projects\research\fuse-ai-agents\scripts\start-ollama-clean.bat
```

**Ollama Installation Path:**
```
C:\Users\Alendia\AppData\Local\Programs\Ollama\ollama app.exe
```

## Troubleshooting

### Ollama doesn't start after restart

1. Check auto-start is configured:
   ```bash
   cscript scripts\verify-ollama-startup.vbs
   ```

2. Manually restart Ollama:
   ```bash
   scripts\restart-ollama.bat
   ```

3. Re-run setup if needed:
   ```bash
   cscript scripts\setup-ollama-startup.vbs
   ```

### "Connection error" in AI agent tools

**Symptoms:** Error messages like "Connection error" when using pqcoder, aider, or other AI tools

**Solution:**

1. Verify Ollama is running:
   ```bash
   tasklist | findstr ollama
   ```

2. If not running, restart:
   ```bash
   scripts\restart-ollama.bat
   ```

3. Test Ollama connection:
   ```bash
   curl http://localhost:11434/api/version
   ```

### Auto-start not working after Windows update

Windows updates may reset registry entries. Re-run setup:

```bash
cscript scripts\setup-ollama-startup.vbs
```

### Want different Ollama installation path

Edit both `start-ollama-clean.bat` and `restart-ollama.bat`, change the path:

```batch
REM Change this line:
start /min "" "C:\Users\Alendia\AppData\Local\Programs\Ollama\ollama app.exe"

REM To your Ollama installation path:
start /min "" "YOUR_OLLAMA_PATH\ollama app.exe"
```

## Uninstall

To remove auto-start:

```bash
# Using VBScript
cscript scripts\remove-ollama-startup.vbs

# Or using batch file
scripts\remove-ollama-startup.bat
```

The scripts themselves can remain in place for manual use.

## Customization

### Change Startup Delay

Edit `start-ollama-clean.bat`, line 7:

```batch
REM Default: 10 second delay
timeout /t 10 /nobreak >nul

REM Change to 5 seconds:
timeout /t 5 /nobreak >nul

REM Change to 20 seconds:
timeout /t 20 /nobreak >nul
```

### Add Logging

Add logging to track startup behavior:

```batch
REM At the beginning of start-ollama-clean.bat
set LOGFILE=%TEMP%\ollama-startup.log
echo [%DATE% %TIME%] Starting Ollama >> %LOGFILE%

REM Before exit
echo [%DATE% %TIME%] Ollama started >> %LOGFILE%
```

### Run Windowed (Not Minimized)

Edit `start-ollama-clean.bat`, line 17:

```batch
REM Default: minimized
start /min "" "C:\Users\Alendia\AppData\Local\Programs\Ollama\ollama app.exe"

REM Change to normal window:
start "" "C:\Users\Alendia\AppData\Local\Programs\Ollama\ollama app.exe"
```

## Why This Approach?

### Registry Startup vs Task Scheduler

We use Windows Registry (HKCU\Run) because:

**Advantages:**
- No admin privileges required
- Simple setup and removal
- Reliable execution at login
- Easy to verify and troubleshoot

**Task Scheduler Alternative:**
- Requires admin privileges
- More complex configuration
- Better control over execution conditions
- Available in `setup-ollama-startup.ps1` for advanced users

### Why Kill Processes First?

Ollama sometimes leaves processes running after system restart that:
- Consume resources but don't respond
- Block new Ollama instances from starting
- Cause "Connection error" in AI tools

By killing these processes first, we ensure:
- Clean state for new instance
- No port conflicts
- Proper initialization
- Reliable connectivity

## Support

### Check Ollama Status

```bash
# Check if running
tasklist | findstr ollama

# Check Ollama API
curl http://localhost:11434/api/version

# Check loaded models
curl http://localhost:11434/api/tags
```

### Common Commands

```bash
# Manual restart
scripts\restart-ollama.bat

# Verify auto-start
cscript scripts\verify-ollama-startup.vbs

# Enable auto-start
cscript scripts\setup-ollama-startup.vbs

# Disable auto-start
cscript scripts\remove-ollama-startup.vbs
```

## Files

```
scripts/
├── start-ollama-clean.bat              ← Auto-run at startup
├── restart-ollama.bat                  ← Manual restart
├── setup-ollama-startup.vbs            ← Setup auto-start (RECOMMENDED)
├── verify-ollama-startup.vbs           ← Check status
├── remove-ollama-startup.vbs           ← Remove auto-start
├── setup-ollama-startup.ps1            ← Task Scheduler method (advanced)
├── setup-ollama-startup-simple.bat     ← Batch setup method
├── remove-ollama-startup.bat           ← Batch remove method
└── README.md                           ← This file
```

## License

These scripts are provided as-is for use with Ollama. Modify as needed for your environment.
