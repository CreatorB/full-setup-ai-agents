# OpenClaw Agent

## Overview

OpenClaw is the secondary AI agent in the FUSE stack, replacing Hermes Agent. It runs natively on Windows via Node.js and connects to Ollama for local LLM inference. Unlike Hermes (which required WSL), OpenClaw launches instantly and supports messaging channels like Telegram for remote interaction.

## Key Differences from Hermes

| Aspect | Hermes (old) | OpenClaw (new) |
|---|---|---|
| Runtime | WSL (Kali Linux) | Native Windows (Node.js) |
| Startup | Slow (WSL boot) | Fast (native process) |
| Messaging | Terminal only | Telegram, Discord, WhatsApp, and more |
| Skills | Limited custom scripts | 8 built-in + custom workspace skills |
| Model swap | Manual per session | Auto-swap fallback chain + in-chat switching |
| Multi-agent | Single agent | Multiple agents (chat + tool calling) |
| Memory | Basic | Persistent cross-session via workspace files |
| Background | Requires open terminal | Gateway runs as Windows auto-start service |

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

### Config Files

| File | Location | Purpose |
|---|---|---|
| `openclaw.json` | `~/.openclaw/` | Main config (models, agents, channels, gateway) |
| `.env` | `~/.openclaw/` | Environment variables (API keys, tokens) |
| `SOUL.md` | `~/.openclaw/workspace/` | Agent personality and behavior rules |
| `USER.md` | `~/.openclaw/workspace/` | Information about the user |
| `IDENTITY.md` | `~/.openclaw/workspace/` | Agent identity (name, vibe, emoji) |

**Important:** OpenClaw reads `SOUL.md`, `USER.md`, and `IDENTITY.md` from the workspace directory — NOT from `personality.md` in the config root. If you want to customize the agent's behavior, edit the workspace files.

### Key Settings After Onboarding

Onboarding auto-detects Ollama models but may set `contextWindow` too high. On systems with 16GB RAM, reduce to 32768 for all models to avoid out-of-memory errors:

```powershell
# Check current config
openclaw config get agents.defaults.model

# Example: change primary model
openclaw config set agents.defaults.model.primary "ollama/aikid123/Qwen3-coder:latest"
```

## Multi-Agent Architecture

OpenClaw supports multiple agents with different models and purposes. Each agent is defined in `agents.list` in `openclaw.json`.

### Default Setup: Chat Agent + Tool Calling Agent

```json
{
  "agents": {
    "list": [
      {
        "id": "main",
        "default": true,
        "name": "Qwen3-coder",
        "identity": { "name": "Qwen3-coder" },
        "model": {
          "primary": "ollama/aikid123/Qwen3-coder:latest",
          "fallbacks": [
            "ollama/fredrezones55/Jan-code:Q4_K_M",
            "ollama/fredrezones55/qwen3.5-opus:4b",
            "ollama/relational/orlex:latest",
            "ollama/rardiolata/CodeTito:latest",
            "ollama/softw8/Nanbeige4.1-3B-q4_K_M:latest",
            "google/gemini-2.5-flash",
            "nvidia/meta/llama-3.3-70b-instruct"
          ]
        }
      },
      {
        "id": "tcall",
        "name": "Nanbeige-tcall",
        "identity": { "name": "Nanbeige-tcall" },
        "model": {
          "primary": "ollama/softw8/Nanbeige4.1-3B-q4_K_M:latest",
          "fallbacks": [
            "google/gemini-2.5-flash",
            "nvidia/meta/llama-3.3-70b-instruct"
          ]
        }
      }
    ]
  },
  "bindings": [
    { "agentId": "main", "match": { "channel": "telegram", "accountId": "default" } }
  ]
}
```

### Why Two Agents?

Most small local models (1-4GB) can chat but **cannot perform tool calling** (executing shell commands, reading files, invoking skills). Only certain models support tool calling reliably:

| Agent | Model | Chat | Tool Calling | Use Case |
|---|---|---|---|---|
| **main** | Qwen3-coder (1.4GB) | Yes | No | Fast chat, code Q&A, explanations |
| **tcall** | Nanbeige4.1 (2.5GB) | Yes | Yes | Disk check, ping, GitHub, email, skills |

### Routing

- All Telegram messages go to `main` agent by default (via bindings)
- To use `tcall` agent: spawn via `/subagents spawn tcall` or switch model via `/model`
- See "Switching Models in Telegram" section below

## Provider: Ollama (Local-First)

OpenClaw uses Ollama as the **primary** LLM provider. All inference happens locally on your machine. Cloud providers (Gemini, NVIDIA) are available as fallbacks.

### Full Fallback Chain

```
Qwen3-coder (1.4GB, fast chat)
  -> Jan-code (2.7GB, balanced)
    -> Qwen3.5-opus (3.4GB, heavy reasoning)
      -> Orlex (3.3GB, backup)
        -> CodeTito (2.0GB, backup)
          -> Nanbeige4.1 (2.5GB, tool calling)
            -> Gemini Flash (cloud, free tier)
              -> NVIDIA Llama 3.3 (cloud, free tier)
```

Set `OLLAMA_KEEP_ALIVE=0` in `.env` to unload the previous model when swapping (critical for 4GB VRAM GPUs).

## Launcher Scripts (Terminal)

| Command | Model | Purpose |
|---|---|---|
| `ocdev` | Jan-code | Daily coding (default) |
| `ocqcoder` | Qwen3-coder | Fast code with thinking |
| `ocplan` | Qwen3.5-opus | Heavy reasoning and planning |
| `octito` | CodeTito | Backup coding model |
| `octool` | Nanbeige4.1 | Tool calling mode (shell, skills, GitHub) |
| `octeach` | Jan-code + skills | Teaching assistant mode |
| `ocislami` | Jan-code + skills | Islamic daily assistant mode |
| `ocmodel <model>` | Any Ollama model | Manual model picker |
| `ocmodels` | - | Show all available models |

Scripts are located at `C:\Users\<username>\scripts\` and must be in your PATH.

## Switching Models in Telegram

You can list and switch models directly in Telegram chat without restarting the gateway:

| Command | Description |
|---|---|
| `/models` | List all available models (local + cloud) |
| `/model status` | Show which model is currently active |
| `/model ollama/aikid123/Qwen3-coder:latest` | Switch to Qwen3-coder |
| `/model ollama/softw8/Nanbeige4.1-3B-q4_K_M:latest` | Switch to Nanbeige (tool calling) |
| `/model google/gemini-2.5-flash` | Switch to Gemini Flash (cloud) |
| `/model nvidia/meta/llama-3.3-70b-instruct` | Switch to NVIDIA Llama (cloud) |

**Notes:**
- Model switch applies to the **current session only**. Sending `/new` resets to the default model (Qwen3-coder).
- To check disk space, network, or run commands: switch to Nanbeige or Gemini first, then send the command.
- Use `/status` after a response to see which model actually answered (useful when fallback occurs).

### Recommended Workflow

```
# Normal chat (fast, default)
/new
hi, explain this Go error: <paste>

# Need tool calling (switch model first)
/model ollama/softw8/Nanbeige4.1-3B-q4_K_M:latest
check my disk space
ping 192.168.1.1
show open issues in CreatorB/fuse-ai-agents

# Back to fast chat
/model ollama/aikid123/Qwen3-coder:latest
```

## Built-in Skills

| Skill | Status | Description | Requires |
|---|---|---|---|
| coding-agent | Active | Delegate coding tasks to Codex/Claude/Pi | - |
| gh-issues | Active | Manage GitHub issues, PRs, CI runs | `gh` CLI (system-wide) |
| github | Active | GitHub operations via `gh` CLI | `gh` CLI (system-wide) |
| healthcheck | Active | Host security hardening and diagnostics | - |
| node-connect | Active | Diagnose OpenClaw node connections | - |
| skill-creator | Active | Create and audit custom AgentSkills | - |
| weather | Active | Weather forecasts via wttr.in | - |
| himalaya | Disabled | Read/send email via IMAP/SMTP | `himalaya` CLI (removed) |

### Skill Status Notes

**himalaya (email) — disabled:** The `himalaya` binary and config (`~/.config/himalaya/config.toml`) have been removed. Email credentials are no longer stored on disk. To re-enable: install himalaya and recreate the config.

**gh/gh-issues (GitHub) — active via system install:** `gh` is installed system-wide via `choco install gh`. Both GitHub skills remain ready. To fully disable, uninstall with `choco uninstall gh` (Admin PowerShell required).

### Disabling Skills on a Work PC

Skills are auto-detected by binary presence on `PATH`. To disable a skill: remove its binary.

```powershell
# Disable himalaya (email)
Remove-Item ~\.config\himalaya\config.toml -Force   # removes credentials
Remove-Item C:\Users\<username>\scripts\himalaya.exe -Force

# Disable gh (GitHub) — requires uninstalling system-wide
choco uninstall gh  # Admin PowerShell

# Verify skill status
openclaw skills list
```

After removal, the skill shows `△ needs setup` instead of `✓ ready` and OpenClaw will not attempt to use it.

### Email Setup (Himalaya) — Reference

If you want to re-enable email in a future setup, himalaya supports multiple accounts via `~/.config/himalaya/config.toml`:

```toml
# Example: Gmail account
[accounts.personal]
default = true
email = "user@gmail.com"
display-name = "Your Name"
backend.type = "imap"
backend.host = "imap.gmail.com"
backend.port = 993
backend.encryption.type = "tls"
backend.login = "user@gmail.com"
backend.auth.type = "password"
backend.auth.cmd = "echo YOUR_APP_PASSWORD"
message.send.backend.type = "smtp"
message.send.backend.host = "smtp.gmail.com"
message.send.backend.port = 465
message.send.backend.encryption.type = "tls"
message.send.backend.login = "user@gmail.com"
message.send.backend.auth.type = "password"
message.send.backend.auth.cmd = "echo YOUR_APP_PASSWORD"
```

For Gmail: generate an App Password at https://myaccount.google.com/apppasswords

Verify: `himalaya account doctor personal`

## Custom Workspace Skills (7 Planned)

| Skill | Requires LLM | Trigger | Description |
|---|---|---|---|
| coding-assistant | Yes | On-demand | Multi-stack coding: Go, Flutter, PHP, JS, Drupal, Laravel, Next.js, and more |
| doc-writer | Yes | On-demand | Multi-lingual documentation: Indonesian, English, Arabic |
| notif-monitor | No | Cron (5 min) | Unified alerts: email, WhatsApp groups, Telegram groups |
| student-grader | Yes | Triggered | Grade student assignments from email attachments |
| infra-monitor | No | Cron (3 min) | MikroTik, UniFi, Aruba, CCTV Xiaomi 360, power outage detection |
| teaching-material | Yes | On-demand | Generate slides, quizzes, lab modules for grades 7-12 |
| daily-planner | Yes | Cron (04:00) | Smart daily schedule aggregating data from all skills |

These are currently skeleton/README only. Implementation to be added as skills are built.

## Messaging: Telegram

### Setup

1. Open Telegram and search for **@BotFather**
2. Send `/newbot` and follow the prompts to create a bot
3. Copy the bot token
4. Configure: `openclaw config set channels.telegram.botToken "<token>"`
5. Restart gateway: `openclaw gateway stop && openclaw gateway`
6. Send a message to your bot. You will receive a **pairing code**.
7. Approve: `openclaw pairing approve telegram <CODE>`

### All Telegram Commands

| Command | Description |
|---|---|
| `/new` or `/reset` | Reset session (start fresh, revert to default model) |
| `/status` | Show active model, token usage, and cost |
| `/models` | List all available models |
| `/model <id>` | Switch to a specific model for this session |
| `/model status` | Show which model is active |
| `/think <level>` | Set reasoning depth: `off`, `minimal`, `low`, `medium`, `high`, `xhigh` |
| `/compact` | Compress context with summary (when chat gets long) |
| `/usage off\|tokens\|full` | Control usage footer display |
| `/verbose on\|off` | Toggle verbose output |
| `/subagents spawn <id>` | Spawn a named agent (e.g., `tcall`) |
| `/subagents list` | List active subagents |
| `/subagents kill <id>` | Stop a subagent |
| `/restart` | Restart gateway (owner only) |

### Practical Workflows via Telegram

**Code review while working on another project:**
```
"review this Go function: <paste code>"
"write unit tests for this Flutter widget"
"explain this error in Indonesian: <paste error>"
"create a REST API endpoint in Laravel for user registration"
```

**Generate teaching materials before class:**
```
"create 10 multiple choice questions about HTML for grade 10"
"create a lab module for Excel basics, grade 8"
"create a presentation outline for Computer Networks, grade 11"
```

**System monitoring (switch to tool-calling model first):**
```
/model ollama/softw8/Nanbeige4.1-3B-q4_K_M:latest
check my disk space
ping 192.168.1.1
show open issues in CreatorB/fuse-ai-agents
check my inbox
```

**Documentation in multiple languages:**
```
"write a README.md in English for this project: <description>"
"translate this paragraph to Arabic: <text>"
"add Indonesian inline comments to this PHP code"
```

### Tips for Effective Use

1. **Reset sessions between topics.** Send `/new` when switching contexts. This prevents context pollution and reverts to the default fast model.
2. **Use `/think` strategically.** Set `/think low` for simple Q&A (faster). Set `/think high` for architecture decisions or complex debugging.
3. **Switch models for tool calling.** Default model (Qwen3-coder) is fast but cannot execute commands. Switch to Nanbeige or Gemini when you need shell access, email, or GitHub operations.
4. **Use `/compact` for long chats.** When a conversation exceeds ~20 messages, context gets large. `/compact` summarizes history and frees token space.
5. **Send files and images.** Screenshot an error, photo a whiteboard, or attach a code file. The bot can process them.
6. **Gateway runs in background.** Auto-starts on Windows login. No terminal needed.
7. **Use `/status` to check model.** After a response, `/status` shows which model actually answered (useful when fallback occurs).

## Gateway Management

```powershell
# Start gateway (foreground, for debugging)
openclaw gateway --port 18789 --verbose

# Install as Windows auto-start service
openclaw gateway install --port 18789

# Stop gateway
openclaw gateway stop

# Check channel status
openclaw channels status

# View recent logs
openclaw channels logs

# Run diagnostics
openclaw doctor

# List agents and routing
openclaw agents list --bindings

# List available models
openclaw models list

# List active skills
openclaw skills list
openclaw skills check
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
7. **Pairing protects your bot.** Unknown Telegram users receive a pairing code. Only you can approve them via `openclaw pairing approve telegram <CODE>`.

## Cloud Fallback (Optional)

Cloud providers are available as the last fallback after all local models. They are configured in `openclaw.json` under `models.providers`.

### Configured Cloud Providers

| Provider | Model | Context | Auth |
|---|---|---|---|
| Google | gemini-2.5-flash | 1M tokens | API key in `.env` |
| NVIDIA | meta/llama-3.3-70b-instruct | 128K tokens | API key in `.env` |

### When Cloud is Used

Cloud models only activate when:
1. ALL local models in the fallback chain have failed or timed out
2. You explicitly switch via `/model google/gemini-2.5-flash` in Telegram
3. You use the `octool` launcher which has Nanbeige -> Gemini -> NVIDIA chain

### Adding More Cloud Providers

Edit `~/.openclaw/openclaw.json` and add to `models.providers`:

```json
{
  "google": {
    "apiKey": "env:GEMINI_API_KEY",
    "baseUrl": "https://generativelanguage.googleapis.com/v1beta",
    "api": "openai-completions",
    "models": [
      {
        "id": "gemini-2.5-flash",
        "name": "Gemini 2.5 Flash (Free Tier)",
        "reasoning": true,
        "input": ["text", "image"],
        "contextWindow": 1048576,
        "maxTokens": 8192
      }
    ]
  }
}
```

Store API keys in `~/.openclaw/.env`, never hardcode in `openclaw.json`.

### Cloud Security Rules

- Local models are ALWAYS tried before cloud
- Student grades, personal data, client code: NEVER sent to cloud
- Cloud API keys stored in `.env` (gitignored, never committed)
- Use `/status` to verify which model (local vs cloud) handled your request
