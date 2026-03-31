# OpenClaw Performance Guide (4GB VRAM / GTX 1650)

## Hardware Profile

| Component | Spec | Impact |
|---|---|---|
| GPU | NVIDIA GTX 1650 4GB | Only 1 model in VRAM at a time |
| RAM | 16 GB | Shared with GPU for overflow layers |
| Storage | SSD | Fast model loading |

## Critical Environment Variables

Set these in `~/.openclaw/.env`:

```env
OLLAMA_KEEP_ALIVE=0              # Unload model immediately after swap (frees VRAM)
OLLAMA_NUM_PARALLEL=1            # Only 1 concurrent request (prevents OOM)
OLLAMA_MAX_LOADED_MODELS=1       # Only 1 model in VRAM at a time
```

Without these, Ollama may try to keep multiple models loaded, causing out-of-memory errors or extreme slowness.

## Context Window Optimization

### The Problem

Onboarding auto-detects models and may set `contextWindow` to 262144 (256K tokens). This requires ~37GB RAM for some models — far more than available.

### The Fix

Set `contextWindow: 32768` (32K) for all local models in `~/.openclaw/openclaw.json`. This is the safe maximum for 4GB VRAM:

- **32K context** = safe maximum for 4GB VRAM with Q4_K_M quantized models (1-4GB)
- **16K context** = too small, may cause broken responses (system prompt truncated)
- **64K+ context** = will cause OOM errors or extreme slowness
- **262K context** (onboard default) = will crash, requires 37GB+ RAM

For cloud models (Gemini, NVIDIA), context window can remain large since inference happens remotely.

### Model Context Sizes in Config

```json
{
  "models": {
    "providers": {
      "ollama": {
        "models": [
          {
            "id": "aikid123/Qwen3-coder:latest",
            "contextWindow": 32768,
            "maxTokens": 8192
          }
        ]
      },
      "google": {
        "models": [
          {
            "id": "gemini-2.5-flash",
            "contextWindow": 1048576,
            "maxTokens": 8192
          }
        ]
      }
    }
  }
}
```

## Timeout Tuning

On 4GB VRAM, model loading takes 2-10 seconds. Set appropriate timeouts to avoid false failures:

```json
{
  "agents": {
    "defaults": {
      "compaction": {
        "timeoutSeconds": 120
      },
      "subagents": {
        "maxConcurrent": 1,
        "runTimeoutSeconds": 120
      }
    }
  },
  "tools": {
    "exec": {
      "timeoutSec": 120,
      "backgroundMs": 5000
    },
    "web": {
      "search": { "timeoutSeconds": 15 },
      "fetch": { "timeoutSeconds": 15 }
    }
  }
}
```

Key points:
- `compaction.timeoutSeconds: 120` — compaction uses LLM, 2 min is enough for local models
- `subagents.maxConcurrent: 1` — only 1 subagent at a time (single model in VRAM)
- `exec.backgroundMs: 5000` — background commands after 5 seconds (faster feedback in Telegram)

## Session & Disk Management

Local models generate smaller sessions, but over time disk usage grows. Set maintenance limits:

```json
{
  "session": {
    "maintenance": {
      "mode": "enforce",
      "pruneAfter": "14d",
      "maxEntries": 200,
      "rotateBytes": "5mb"
    }
  }
}
```

This automatically prunes sessions older than 14 days and rotates logs at 5MB.

## Context Pruning

Enable automatic context pruning to keep conversations within the 32K window:

```json
{
  "agents": {
    "defaults": {
      "compaction": {
        "mode": "default",
        "reserveTokensFloor": 8000
      },
      "contextPruning": {
        "mode": "cache-ttl",
        "ttl": "120m"
      }
    }
  }
}
```

- `reserveTokensFloor: 8000` — always keep 8K tokens free for the next response
- `contextPruning.ttl: 120m` — prune cached context older than 120 minutes (increased from 30m to reduce background CPU cycles)
- Use `/compact` in Telegram when conversations get long

**Why 120m instead of 30m?** With `ttl: 30m`, OpenClaw checks and clears cached context every 30 minutes even when idle. On a work PC this adds unnecessary background CPU activity. 120m is a better balance — context still gets pruned regularly, but background cycles are 4x less frequent.

## Gateway Background CPU Usage

The OpenClaw gateway is a persistent Node.js process that runs continuously in the background. On a work PC, this causes intermittent CPU spikes even when no AI inference is running.

### Root Causes

| Source | Behavior | Impact |
|---|---|---|
| Telegram long-polling | Keeps a persistent HTTP connection to Telegram; reconnects every ~30s when idle | Periodic CPU on reconnect |
| Node.js event loop | Node.js process always alive, GC cycles run periodically | Low but constant background CPU |
| Context pruning | Background timer checks context age (now 120m interval) | Minimal after tuning |
| Session maintenance | Prunes old sessions at `pruneAfter` interval (14d) | Very occasional |

### Mitigation Options

**Option 1: Stop gateway when not needed (most effective)**

```powershell
# Stop — no more Telegram polling, near-zero CPU
openclaw gateway stop

# Restart when you need the bot
openclaw gateway
```

**Option 2: Remove the auto-start entry (if installed as Windows service)**

```powershell
# If installed with: openclaw gateway install --port 18789
# Remove with:
openclaw gateway uninstall
```

Then start manually when needed: `openclaw gateway`

**Option 3: Keep running, reduce polling overhead**

The config changes already applied for 120m context pruning help, but Telegram polling itself cannot be disabled without stopping the gateway. This is inherent to how Telegram bots work.

### Checking Gateway Resource Usage

```powershell
# Check which Node.js processes are running
tasklist /FI "IMAGENAME eq node.exe"

# Check OpenClaw gateway status
openclaw channels status

# View gateway logs
openclaw channels logs
```

## Loop Detection

Prevent runaway tool calling loops (common with small local models):

```json
{
  "tools": {
    "loopDetection": {
      "enabled": true,
      "warningThreshold": 5,
      "criticalThreshold": 10
    }
  }
}
```

## Telegram Channel Optimization

```json
{
  "channels": {
    "telegram": {
      "streaming": "off"
    }
  }
}
```

- `streaming: "off"` — send complete response at once (avoids partial message edits which are slow with local models)
- With streaming on, Telegram edits messages multiple times per response, adding latency

## Message Queue Tuning

```json
{
  "messages": {
    "queue": {
      "mode": "steer",
      "debounceMs": 1500,
      "cap": 10
    },
    "inbound": {
      "debounceMs": 1500
    }
  }
}
```

- `debounceMs: 1500` — wait 1.5 seconds before processing (catches multi-message bursts)
- `cap: 10` — max 10 queued messages (prevents overload)
- `mode: "steer"` — newer messages override older queued ones

## Model Selection for Performance

| Model | Size | Load Time | Response Speed | Tool Calling | Best For |
|---|---|---|---|---|---|
| Qwen3-coder | 1.4 GB | ~2s | Fast | No | Quick chat, code Q&A |
| Nanbeige4.1 | 2.5 GB | ~3s | Medium | Yes | Commands, skills, shell |
| Jan-code | 2.7 GB | ~4s | Medium | No | Balanced daily coding |
| CodeTito | 2.0 GB | ~3s | Medium | No | Backup coding |
| Qwen3.5-opus | 3.4 GB | ~5s | Slow | No | Heavy reasoning |
| Orlex | 3.3 GB | ~5s | Slow | No | Planning, architecture |
| Gemini Flash | Cloud | ~1s | Fast | Yes | Long context, tool calling |
| NVIDIA Llama | Cloud | ~1s | Fast | Yes | Fallback |

### Recommendation

Use **Qwen3-coder** (1.4GB) as primary — fastest load, good enough for chat. Switch to **Nanbeige** or **Gemini** when you need tool calling. Use `/model` in Telegram to switch on the fly.

## Pre-Warming Models

When switching models, the first inference is slow (model loading). Pre-warm with:

```bash
curl -s http://127.0.0.1:11434/api/generate \
  -d '{"model":"aikid123/Qwen3-coder:latest","prompt":"hi","stream":false,"options":{"num_ctx":4096}}'
```

Or in Telegram: send a simple message immediately after `/model` switch to trigger loading.

## Monitoring Performance

```powershell
# Check what model is loaded in VRAM
curl http://127.0.0.1:11434/api/ps

# Check GPU usage
nvidia-smi

# Check OpenClaw gateway status
openclaw channels status

# View gateway logs for timeout/fallback events
openclaw channels logs
```

## Common Issues & Fixes

| Issue | Cause | Fix |
|---|---|---|
| "model requires more system memory" | contextWindow too high | Set `contextWindow: 32768` in openclaw.json |
| Agent timeout | Model not loaded in VRAM | Pre-warm model, increase timeouts |
| GPU 100% hang | Multiple models trying to load | Set `OLLAMA_MAX_LOADED_MODELS=1` |
| Slow responses | Model partially on CPU | Use smaller model (Qwen3-coder 1.4GB) |
| Wrong model after `/new` | Stale session routing | Clear sessions in `~/.openclaw/agents/*/sessions/` |
| Tool calling fails | Model too small for tools | Switch to Nanbeige or Gemini via `/model` |
| CPU spikes on work PC | Telegram long-polling + Node.js event loop | Stop gateway when not in use: `openclaw gateway stop` |
| High idle CPU | contextPruning TTL too short | Set `contextPruning.ttl: "120m"` in openclaw.json |
