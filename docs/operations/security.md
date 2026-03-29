# Security

## General Rules

- Treat public templates as examples, not blind copy-paste targets for production systems.
- Review all launcher scripts, shell commands, and configuration files before running them.
- Never commit real credentials to the repository.

## Do Not Commit

- API keys and tokens (Telegram bot token, Gemini key, etc.)
- Auth files and session state
- Agent session data and conversation history
- Cache, logs, and temporary files
- Private `.env` files with real values

## OpenClaw Security Model

### Gateway Access

| Setting | Recommended Value | Purpose |
|---|---|---|
| `gateway.bind` | `loopback` | Gateway only accessible from localhost |
| `gateway.auth.mode` | `token` | Require token for gateway WebSocket connections |

The gateway listens on `ws://127.0.0.1:18789` by default. It is not exposed to the network.

### Messaging Channel Security

| Setting | Recommended Value | Purpose |
|---|---|---|
| `channels.telegram.dmPolicy` | `pairing` | Unknown senders must present a pairing code |
| `channels.telegram.groupPolicy` | `allowlist` | Bot only responds in explicitly whitelisted groups |

**Pairing workflow:**
1. Unknown user sends a message to the bot
2. Bot replies with a pairing code (e.g., `PR7HXFVV`)
3. Bot owner approves: `openclaw pairing approve telegram <CODE>`
4. Only approved senders can interact with the bot

### Tools and Execution

OpenClaw with `tools.profile: "coding"` can:
- Execute shell commands on the host machine
- Read and write files in the workspace
- Access the local network (for monitoring, API calls)
- Install packages via npm/pip

**Guidelines:**
- Do not give the bot instructions that could be interpreted as destructive commands
- Be specific in your requests to avoid unintended actions
- The bot does not execute commands without being asked, but local models may occasionally be unpredictable

### Sensitive Data Protection

Data that must **never** be sent to cloud LLMs:
- Student grades and personal information
- Freelance client confidential code
- API keys, passwords, and credentials
- `.env` file contents
- Private religious data (memorization progress, personal prayers)

When `OPENCLAW_SENSITIVE_DATA_LOCAL_ONLY=true`, these categories are handled exclusively by Ollama (local inference).

### Token Security

- **Telegram bot token:** Stored in `~/.openclaw/openclaw.json`. Anyone with this token can control the bot. Do not share it.
- **Gateway auth token:** Stored in the same config file. Required for WebSocket connections to the gateway.
- **Ollama API key:** Set to `ollama-local` (placeholder). Ollama does not require authentication on localhost.

### Network Exposure

| Component | Binding | Exposure |
|---|---|---|
| OpenClaw Gateway | `127.0.0.1:18789` | Localhost only |
| Ollama | `127.0.0.1:11434` | Localhost only |
| Telegram Bot | Outbound polling | No inbound ports needed |

No inbound ports are opened. Telegram uses outbound HTTPS polling.

## Template Sync Security

When syncing live configs to the public repository via `refresh-public-templates.ps1`:

1. **Strip real tokens** before pushing. Replace with placeholders.
2. **Never sync** `~/.openclaw/openclaw.json` directly (contains real bot token and gateway auth token).
3. **Use `.env.example`** with empty values for the public repository.
4. **Private backup** (`backup-full-setup-ai-agents/`) may contain real values but must never be pushed to a public remote.

## Incident Response

If you suspect unauthorized access:

```powershell
# Stop the gateway immediately
openclaw gateway stop

# Revoke the Telegram bot token via @BotFather
# Send /revoke to @BotFather in Telegram

# Generate a new gateway auth token
openclaw config set gateway.auth.token "<new-random-token>"

# Review approved senders
# Remove any unknown approvals
```
