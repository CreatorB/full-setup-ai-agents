# OpenClaw Agent

## Overview

OpenClaw is the secondary AI agent in the FUSE stack, replacing Hermes Agent. It runs natively on Windows via Node.js and connects to Ollama for local LLM inference. Unlike Hermes (which required WSL), OpenClaw launches instantly and supports messaging channels like Telegram for remote interaction.

## Key Differences from Hermes

| Aspect | Hermes (old) | OpenClaw (new) |
|---|---|---|
| Runtime | WSL (Kali Linux) | Native Windows (Node.js) |
| Startup | Slow (WSL boot) | Fast (native process) |
| Messaging | Terminal only | Telegram, Discord, WhatsApp, and more |
| Skills | Limited custom scripts | 7 workspace skills + 100+ built-in |
| Model swap | Manual per session | Auto-swap fallback chain |
| Memory | Basic | Persistent cross-session |
| Background | Requires open terminal | Gateway runs as Windows service |

## Installation

```powershell
# Step 1: Ensure Node.js v22+ is installed
node --version  # Must be >= 22.14.0

# If using nvm4w:
nvm install 22
nvm use 22

# Step 2: Install OpenClaw (Windows native)
iwr -useb https://openclaw.ai/install.ps1 | iex

# Step 3: Run onboarding (choose Ollama as provider)
openclaw onboard --install-daemon

# Step 4 (alternative): Non-interactive setup
openclaw onboard --non-interactive --accept-risk --auth-choice ollama --mode local
```

## Configuration

Config file: `~/.openclaw/openclaw.json`

OpenClaw auto-detects installed Ollama models during onboarding. Key settings to verify after setup:

```json
{
  "agents": {
    "defaults": {
      "model": {
        "primary": "ollama/aikid123/Qwen3-coder:latest",
        "fallbacks": [
          "ollama/fredrezones55/Jan-code:Q4_K_M",
          "ollama/fredrezones55/qwen3.5-opus:4b",
          "ollama/relational/orlex:latest"
        ]
      }
    }
  }
}
```

Important notes:
- Onboard may set `contextWindow` to 262144 (256K). On systems with 16GB RAM, reduce to 32768 to avoid out-of-memory errors.
- Set `"streaming": false` for models that struggle with streaming tool calls.
- Use `openclaw config set <path> <value>` to update settings without editing JSON directly.

## Provider: Ollama (Local-First)

OpenClaw uses Ollama as the **sole** LLM provider. All inference happens locally on your machine. Cloud providers (Claude, Gemini, NVIDIA) are available as optional fallbacks but disabled by default.

### Auto-Swap Fallback Chain

When the primary model fails or times out, OpenClaw automatically tries the next model:

```
Qwen3-coder (1.4GB, fast)
  -> Jan-code (2.7GB, balanced)
    -> Qwen3.5-opus (3.4GB, heavy reasoning)
      -> Orlex (3.3GB, backup)
        -> CodeTito (2.0GB, backup)
```

Set `OLLAMA_KEEP_ALIVE=0` in `.env` to unload the previous model when swapping (critical for 4GB VRAM GPUs).

## Launcher Scripts

| Command | Model | Purpose |
|---|---|---|
| `ocdev` | Jan-code | Daily coding (default) |
| `ocqcoder` | Qwen3-coder | Fast code with thinking |
| `ocplan` | Qwen3.5-opus | Heavy reasoning and planning |
| `octito` | CodeTito | Backup coding model |
| `octeach` | Jan-code + skills | Teaching assistant mode |
| `ocislami` | Jan-code + skills | Islamic daily assistant mode |
| `ocmodel <model>` | Any Ollama model | Manual model picker |
| `ocmodels` | - | Show all available models |

Scripts are located at `C:\Users\<username>\scripts\` and must be in your PATH.

## Skills (7 Workspace Skills)

| Skill | Requires LLM | Trigger | Description |
|---|---|---|---|
| coding-assistant | Yes | On-demand | Multi-language coding: Go, Flutter, PHP, JS, Drupal |
| doc-writer | Yes | On-demand | Multi-lingual documentation: Indonesian, English, Arabic |
| notif-monitor | No | Cron (every 5 min) | Unified alerts: email, WhatsApp groups, Telegram groups |
| student-grader | Yes | Triggered by notif-monitor | Grade student assignments from email attachments |
| infra-monitor | No | Cron (every 3 min) | MikroTik router, CCTV Xiaomi 360, power outage detection |
| teaching-material | Yes | On-demand | Generate slides, quizzes, lab modules for grades 7-12 |
| daily-planner | Yes | Cron (04:00 + 13:00) | Smart daily schedule aggregating data from all skills |

Skills that do not require LLM run as lightweight cron jobs (no VRAM usage). Skills that require LLM load Ollama on-demand and release VRAM when done.

## Messaging: Telegram

Telegram is the primary (and currently only) messaging channel.

### Setup

1. Open Telegram and search for **@BotFather**
2. Send `/newbot` and follow the prompts to create a bot
3. Copy the bot token
4. Configure: `openclaw config set channels.telegram.botToken "<token>"`
5. Restart gateway: `openclaw gateway stop && openclaw gateway`
6. Send a message to your bot. You will receive a **pairing code**.
7. Approve: `openclaw pairing approve telegram <CODE>`

### Telegram Commands

Use these commands directly in the Telegram chat:

| Command | Description |
|---|---|
| `/status` | Show active model, token usage, and cost |
| `/new` or `/reset` | Reset session (start fresh conversation) |
| `/compact` | Compress context with summary (when chat gets long) |
| `/think <level>` | Set reasoning depth: `off`, `minimal`, `low`, `medium`, `high`, `xhigh` |
| `/verbose on\|off` | Toggle verbose output |
| `/usage off\|tokens\|full` | Control usage footer display |

### Practical Telegram Workflows

**Code review while coding another project:**
```
"review this Go function: <paste code>"
"write unit tests for this Flutter widget"
"explain this error in Indonesian: <paste error>"
```

**Generate teaching materials before class:**
```
"create 10 multiple choice questions about HTML for grade 10"
"create a lab module for Excel basics, grade 8"
"create a presentation outline for Computer Networks, grade 11"
```

**Documentation in multiple languages:**
```
"write a README.md in English for this project: <description>"
"translate this paragraph to Arabic: <text>"
"add Indonesian inline comments to this PHP code"
```

**Quick research and summarization:**
```
"summarize this article: <paste URL or text>"
"compare React vs Flutter for mobile development"
"explain Kubernetes in simple Indonesian"
```

### Tips for Effective Use

1. **Reset sessions between topics.** Send `/new` when switching from coding to teaching to monitoring. This prevents context pollution.
2. **Use `/think` strategically.** Set `/think low` for simple Q&A (faster). Set `/think high` for architecture decisions or complex debugging.
3. **Send files and images.** Screenshot an error, photo a whiteboard, or attach a code file. The bot can process them.
4. **Use `/compact` for long chats.** When a conversation exceeds ~20 messages, context gets large. `/compact` summarizes history and frees token space.
5. **Gateway runs in background.** You do not need to keep a terminal open. The gateway auto-starts on Windows login.

## Gateway Management

```powershell
# Start gateway (foreground, for debugging)
openclaw gateway --port 18789 --verbose

# Start gateway (background service, auto-starts on login)
openclaw gateway install --port 18789

# Stop gateway
openclaw gateway stop

# Check status
openclaw channels status

# View recent logs
openclaw channels logs

# Run diagnostics
openclaw doctor
```

## Security

| Setting | Value | Purpose |
|---|---|---|
| `dmPolicy` | `pairing` | Unknown senders must present a pairing code |
| `groupPolicy` | `allowlist` | Bot only responds in whitelisted groups |
| `gateway.bind` | `loopback` | Gateway only accessible from localhost |
| `tools.profile` | `coding` | Bot can execute shell commands and file operations |

### Security Guidelines

1. **Never share your bot token.** Anyone with the token can impersonate your bot.
2. **Do not add the bot to public groups.** Even with allowlist policy, minimize exposure.
3. **Do not send passwords or API keys via Telegram.** Bot chat is not end-to-end encrypted.
4. **Sensitive data stays local.** Student grades, personal data, client code, and credentials must never be sent to cloud LLMs.
5. **Stop the gateway when not in use** if you prefer minimal attack surface: `openclaw gateway stop`
6. **The `coding` tools profile is powerful.** The bot can execute arbitrary shell commands on your machine. This is by design for a coding assistant, but be mindful of the instructions you give.

## Cloud Fallback (Optional, Disabled by Default)

Cloud providers are available for tasks that exceed local model capabilities. They are disabled by default and should only be enabled after local models have been thoroughly tested.

**When to consider cloud fallback:**
- All local models consistently fail on a specific task type
- Task requires context window larger than 32K tokens
- You need state-of-the-art reasoning that local 4B models cannot provide
- You explicitly want a second opinion from a different model family

**When NOT to use cloud:**
- Student grades, personal data, client confidential code
- Any task local models can handle (even if slower)
- Credentials, `.env` contents, private Islamic data

### Available Cloud Providers

| Provider | Auth Method | Free Tier | Best For |
|---|---|---|---|
| Claude (Anthropic) | Claude Code CLI (already logged in) | Subscription | Complex architecture, multi-file refactoring |
| OpenCode | OpenCode CLI (already installed) | Free tier available | Second opinion, alternative coding agent |
| Gemini (Google) | API key | Free tier (generous) | Long context (1M+), bulk generation |
| NVIDIA NIM | API key | Free tier available | Specialized models, fast inference |
| OpenRouter | API key | Pay-per-token | Access any model on-demand |

### Step 1: Enable Cloud in `.env`

Edit `~/.openclaw/.env` and uncomment the cloud section:

```env
# Uncomment and fill in the providers you want to enable:
OPENCLAW_CLOUD_ENABLED=true
OPENCLAW_MONTHLY_BUDGET_USD=5         # Hard limit, auto-block when exceeded

# Provider API keys (fill only the ones you have):
GEMINI_API_KEY=your-gemini-key-here
NVIDIA_API_KEY=your-nvidia-nim-key-here
OPENROUTER_API_KEY=your-openrouter-key-here

# Claude and OpenCode use their own CLI auth (no key needed here):
# Claude: already authenticated via `claude` CLI
# OpenCode: already authenticated via `opencode` CLI
```

### Step 2: Add Cloud Providers to `openclaw.json`

Run these commands to add cloud providers alongside Ollama:

```powershell
# Add Gemini provider
openclaw config set models.providers.google.apiKey "env:GEMINI_API_KEY"

# Add OpenRouter provider (access to any model)
openclaw config set models.providers.openrouter.apiKey "env:OPENROUTER_API_KEY"
```

Or edit `~/.openclaw/openclaw.json` directly. Add to the `models.providers` section:

```json
{
  "models": {
    "mode": "merge",
    "providers": {
      "ollama": {
        "...existing ollama config..."
      },
      "google": {
        "apiKey": "env:GEMINI_API_KEY",
        "models": [
          {
            "id": "gemini-2.5-flash",
            "name": "Gemini 2.5 Flash (Free Tier)",
            "reasoning": false,
            "input": ["text", "image"],
            "contextWindow": 1048576,
            "maxTokens": 8192
          },
          {
            "id": "gemini-2.5-pro",
            "name": "Gemini 2.5 Pro",
            "reasoning": true,
            "input": ["text", "image"],
            "contextWindow": 1048576,
            "maxTokens": 8192
          }
        ]
      },
      "openrouter": {
        "apiKey": "env:OPENROUTER_API_KEY",
        "baseUrl": "https://openrouter.ai/api/v1",
        "models": [
          {
            "id": "anthropic/claude-opus-4",
            "name": "Claude Opus 4 (via OpenRouter)",
            "reasoning": true,
            "input": ["text", "image"],
            "contextWindow": 200000,
            "maxTokens": 8192
          }
        ]
      },
      "nvidia": {
        "apiKey": "env:NVIDIA_API_KEY",
        "baseUrl": "https://integrate.api.nvidia.com/v1",
        "api": "openai-completions",
        "models": [
          {
            "id": "meta/llama-3.3-70b-instruct",
            "name": "Llama 3.3 70B (NVIDIA NIM)",
            "reasoning": false,
            "input": ["text"],
            "contextWindow": 131072,
            "maxTokens": 4096
          }
        ]
      }
    }
  }
}
```

### Step 3: Configure Cloud Fallback Chain

Add cloud models to the fallback chain so they are only used after all local models fail:

```powershell
openclaw config set agents.defaults.model.fallbacks '["ollama/aikid123/Qwen3-coder:latest","ollama/fredrezones55/Jan-code:Q4_K_M","ollama/fredrezones55/qwen3.5-opus:4b","ollama/relational/orlex:latest","ollama/rardiolata/CodeTito:latest","google/gemini-2.5-flash","openrouter/anthropic/claude-opus-4"]'
```

The resulting fallback chain:

```
Qwen3-coder (local, free)
  -> Jan-code (local, free)
    -> Qwen3.5-opus (local, free)
      -> Orlex (local, free)
        -> CodeTito (local, free)
          -> Gemini Flash (cloud, free tier)
            -> Claude Opus (cloud, paid, last resort)
```

Local models are always tried first. Cloud is the last resort.

### Step 4: Create Cloud Launcher Scripts

Create these scripts in `C:\Users\<username>\scripts\`:

**occlaude.cmd** — Direct Claude access (skips local):
```cmd
@echo off
setlocal
echo [occlaude] WARNING: Cloud mode. Data will be sent to Anthropic API.
echo Do NOT send student grades, personal data, or client code.
echo.
set /p confirm="Continue? (y/n): "
if /i not "%confirm%"=="y" exit /b 0
openclaw chat --model "openrouter/anthropic/claude-opus-4"
```

**ocgemini.cmd** — Direct Gemini access (skips local):
```cmd
@echo off
setlocal
echo [ocgemini] WARNING: Cloud mode. Data will be sent to Google API.
echo Do NOT send student grades, personal data, or client code.
echo.
set /p confirm="Continue? (y/n): "
if /i not "%confirm%"=="y" exit /b 0
openclaw chat --model "google/gemini-2.5-flash"
```

**occloud.cmd** — Auto-pick best available cloud provider:
```cmd
@echo off
setlocal
echo [occloud] WARNING: Cloud mode. Data will be sent to external API.
echo Do NOT send student grades, personal data, or client code.
echo.
set /p confirm="Continue? (y/n): "
if /i not "%confirm%"=="y" exit /b 0
openclaw chat --model "google/gemini-2.5-flash"
```

### Step 5: Set Budget Guard

Prevent unexpected cloud costs:

```powershell
# Set monthly budget limit (in USD)
# Gateway will auto-block cloud requests when budget is exceeded
# and fall back to local models
openclaw config set billing.monthlyBudgetUsd 5
```

Monitor usage:
```
/usage full    # In Telegram: show token counts and estimated cost
/status        # Show current model and session cost
```

### Step 6: Restart and Verify

```powershell
openclaw gateway stop
openclaw gateway

# Verify cloud models are visible
openclaw models list

# Test cloud fallback (send a complex task that local models struggle with)
# The fallback chain should try local first, then escalate to cloud
```

### Cloud Security Checklist

- [ ] `OPENCLAW_CLOUD_ENABLED=true` set in `.env`
- [ ] `OPENCLAW_MONTHLY_BUDGET_USD` set (recommended: 5)
- [ ] `OPENCLAW_SENSITIVE_DATA_LOCAL_ONLY=true` still enabled
- [ ] Cloud launcher scripts (`occlaude`, `ocgemini`) show warning before connecting
- [ ] Local models are listed BEFORE cloud models in the fallback chain
- [ ] No student grades, personal data, or credentials sent to cloud
- [ ] Cloud API keys stored in `.env` (not hardcoded in `openclaw.json`)
