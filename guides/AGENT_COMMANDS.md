# Agent Commands

Unified quick reference for all local coding agents on Windows.

## Aider (Primary Agent — Windows Native)

| Command | Purpose |
|---|---|
| `ajan` | Daily coding with Jan-code |
| `aqcoder` | Fast code with Qwen3-coder |
| `atito` | Backup coding with CodeTito |
| `amodels` | Show available Aider models |

## OpenClaw (Secondary Agent — Windows Native, Replaces Hermes)

### Terminal Commands

| Command | Model | Purpose |
|---|---|---|
| `ocdev` | Jan-code | Daily coding (default) |
| `ocqcoder` | Qwen3-coder | Fast code with thinking |
| `ocplan` | Qwen3.5-opus | Heavy reasoning and planning |
| `octito` | CodeTito | Backup coding model |
| `octeach` | Jan-code + skills | Teaching assistant mode |
| `ocislami` | Jan-code + skills | Islamic daily assistant mode |
| `ocmodel <model>` | Any | Launch with specific Ollama model |
| `ocmodels` | - | Show all available models |

### Gateway Management

| Command | Purpose |
|---|---|
| `openclaw gateway` | Start gateway (foreground) |
| `openclaw gateway stop` | Stop gateway |
| `openclaw gateway install` | Install as Windows auto-start service |
| `openclaw channels status` | Check Telegram and other channel status |
| `openclaw channels logs` | View recent channel logs |
| `openclaw doctor` | Run diagnostics |
| `openclaw models list` | List all available models |

### Telegram Chat Commands

Send these directly in the Telegram conversation with the bot:

| Command | Purpose |
|---|---|
| `/status` | Show active model, tokens used, session cost |
| `/new` or `/reset` | Reset session (start fresh) |
| `/compact` | Compress context with summary |
| `/think <level>` | Set reasoning: `off`, `minimal`, `low`, `medium`, `high`, `xhigh` |
| `/verbose on\|off` | Toggle verbose output |
| `/usage off\|tokens\|full` | Control usage footer |
| `/restart` | Restart gateway (owner only) |
| `/activation mention\|always` | Group activation mode |

### Pairing Commands

| Command | Purpose |
|---|---|
| `openclaw pairing approve <channel> <code>` | Approve a new sender |

## Pi (Lightweight Agent — Windows Native)

| Command | Purpose |
|---|---|
| `pijan` | Daily coding with Jan-code |
| `pqcoder` | Fast code with Qwen3-coder |
| `ptito` | Backup coding with CodeTito |
| `pmodels` | Show available Pi models |
| `pmodel <model>` | Launch with specific model |

## Hermes (Legacy — WSL, Deprecated)

Hermes has been replaced by OpenClaw. Legacy commands are preserved for reference but should not be used:

| Command | Purpose | Replacement |
|---|---|---|
| `hdev` | Daily coding | `ocdev` |
| `hqcoder` | Fast code | `ocqcoder` |
| `htito` | Backup coding | `octito` |
| `hmodels` | Show models | `ocmodels` |
| `hmodel <model>` | Manual model | `ocmodel <model>` |

## Flexible Model Switching

All agents support manual model selection:

```powershell
# Aider (needs --raw-model for provider-prefixed routes)
amodel --raw-model --edit-format whole "ollama_chat/rardiolata/CodeTito"

# OpenClaw (uses exact Ollama model name)
ocmodel "rardiolata/CodeTito:latest"

# Pi (uses exact Ollama model name)
pmodel "rardiolata/CodeTito:latest"
```

## Quick Decision Guide

| Situation | Use |
|---|---|
| Editing files in a repo | Aider (`ajan`) |
| Quick question while coding | OpenClaw via Telegram |
| Generate teaching materials | OpenClaw (`octeach`) or Telegram |
| Monitor infrastructure | OpenClaw gateway (background) |
| Lightweight code chat | Pi (`pijan`) |
| Complex architecture planning | OpenClaw (`ocplan`) |
