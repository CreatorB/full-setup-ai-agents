# OpenClaw Model Guide

## Strategy: Local-First (Ollama Only)

OpenClaw is configured to use Ollama as the sole LLM provider. All inference runs locally on your hardware. Cloud fallback is optional and disabled by default.

## Installed Models

| Model | Size | Context | Best For |
|---|---|---|---|
| aikid123/Qwen3-coder:latest | 1.4 GB | 32K | Fast coding + thinking (PRIMARY) |
| fredrezones55/Jan-code:Q4_K_M | 2.7 GB | 32K | Balanced daily coding |
| fredrezones55/qwen3.5-opus:4b | 3.4 GB | 32K | Heavy reasoning and planning |
| relational/orlex:latest | 3.3 GB | 32K | Architecture and planning backup |
| rardiolata/CodeTito:latest | 2.0 GB | 32K | Coding backup |
| codegemma:2b | 1.6 GB | 8K | Autocomplete (editor integration) |
| nomic-embed-text:latest | 274 MB | 2K | Embeddings and RAG |

## Auto-Swap Fallback Chain

When the primary model fails or times out, OpenClaw automatically tries the next model in the chain:

```
Qwen3-coder (primary, fastest to load)
  |-- fail --> Jan-code (balanced)
                 |-- fail --> Qwen3.5-opus (heavy reasoning)
                                |-- fail --> Orlex (backup)
                                               |-- fail --> CodeTito (last resort)
```

This is configured in `~/.openclaw/openclaw.json` under `agents.defaults.model.fallbacks`.

## VRAM Considerations (4GB GPU)

With a 4GB VRAM GPU (e.g., GTX 1650), only one model fits in VRAM at a time.

**Critical settings:**

```env
OLLAMA_KEEP_ALIVE=0    # Unload previous model immediately when swapping
```

**Context window:** Onboarding may set `contextWindow` to 262144 (256K tokens). This requires ~37GB RAM for some models. **Reduce to 32768** in `~/.openclaw/openclaw.json` for all models:

```json
"contextWindow": 32768
```

**Model load time:** First inference after a swap takes 2-10 seconds (model loading into VRAM). Subsequent inferences are fast. If OpenClaw times out, increase the agent timeout or pre-warm the model:

```bash
curl http://127.0.0.1:11434/api/generate -d '{"model":"aikid123/Qwen3-coder:latest","prompt":"hi","stream":false}'
```

## Launcher Commands

### Quick Launch

| Command | Model | Use Case |
|---|---|---|
| `ocdev` | Jan-code | Daily coding sessions |
| `ocqcoder` | Qwen3-coder | Fast code generation with thinking |
| `ocplan` | Qwen3.5-opus | Complex reasoning and architecture |
| `octito` | CodeTito | Backup coding model |

### Special Modes

| Command | Skills Loaded | Use Case |
|---|---|---|
| `octeach` | teaching-material, student-grader, daily-planner | Teaching assistant |
| `ocislami` | daily-planner, notif-monitor | Islamic daily assistant |

### Flexible

| Command | Description |
|---|---|
| `ocmodel <model>` | Launch with any Ollama model by name |
| `ocmodels` | Display all available models and launcher commands |

## Model Selection Guide

| Task | Recommended Model | Why |
|---|---|---|
| Quick Q&A, simple code | Qwen3-coder | Fast, low VRAM, good enough |
| Daily coding (multi-file) | Jan-code | Balanced quality and speed |
| Architecture decisions | Qwen3.5-opus | Best local reasoning |
| Code review | Qwen3-coder or Jan-code | Speed matters for reviews |
| Documentation writing | Jan-code or Qwen3.5-opus | Quality matters for docs |
| Teaching materials | Jan-code | Good content generation |
| Debugging complex issues | Qwen3.5-opus | Needs deep reasoning |

## Telegram Model Control

Change models on the fly in Telegram:

```
/think low     -> uses primary model with minimal reasoning (fastest)
/think high    -> uses primary model with deep reasoning (slower, better)
/think xhigh   -> maximum reasoning depth
```

Note: `/think` controls reasoning depth, not model selection. Model selection follows the fallback chain automatically.

## Configuration Reference

Full model config location: `~/.openclaw/openclaw.json`

```bash
# View current model config
openclaw config get agents.defaults.model

# Change primary model
openclaw config set agents.defaults.model.primary "ollama/fredrezones55/Jan-code:Q4_K_M"

# List all models OpenClaw can see
openclaw models list
```
