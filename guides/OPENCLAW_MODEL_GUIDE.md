# OpenClaw Model Guide

## Strategy: Local-First (Ollama Primary, Cloud Fallback)

OpenClaw is configured to use Ollama as the primary LLM provider. All inference runs locally on your hardware. Cloud providers (Gemini Flash, NVIDIA Llama) are available as last-resort fallbacks.

## Installed Models

| Model | Size | Context | Reasoning | Tools | Best For |
|---|---|---|---|---|---|
| phi4-mini:3.8b-q4_K_M | 2.5 GB | 32K | No* | Yes | **PRIMARY** — tool calling + step-by-step reasoning |
| aikid123/Qwen3-coder:latest | 1.4 GB | 32K | No | No | Fast coding + thinking |
| fredrezones55/Jan-code:Q4_K_M | 2.7 GB | 32K | No | No | Balanced daily coding |
| fredrezones55/qwen3.5-opus:4b | 3.4 GB | 32K | No | No | Heavy reasoning |
| relational/orlex:latest | 3.3 GB | 32K | No | No | Architecture and planning |
| rardiolata/CodeTito:latest | 2.0 GB | 32K | No | No | Backup coding |
| softw8/Nanbeige4.1-3B-q4_K_M | 2.5 GB | 32K | No | Yes | Backup tool calling |
| codegemma:2b | 1.6 GB | 8K | No | No | Autocomplete (editor) |
| nomic-embed-text:latest | 274 MB | 2K | No | No | Embeddings and RAG |
| **gemini-2.5-flash** (cloud) | - | 1M | Yes | Yes | Cloud fallback (free) |
| **meta/llama-3.3-70b** (cloud) | - | 128K | No | Yes | Cloud fallback (free) |

## Auto-Swap Fallback Chain

When the primary model fails or times out, OpenClaw automatically tries the next model:

```
Phi4-mini (primary, reasoning + tools)
  |-- fail --> Qwen3-coder (fast chat)
                 |-- fail --> Jan-code (balanced)
                                |-- fail --> Qwen3.5-opus (heavy reasoning)
                                               |-- fail --> Orlex (backup)
                                                              |-- fail --> CodeTito (backup)
                                                                             |-- fail --> Nanbeige4.1 (tool calling backup)
                                                                                            |-- fail --> Gemini Flash (cloud)
                                                                                                           |-- fail --> NVIDIA Llama (cloud)
```

## Multi-Agent Setup

| Agent | Primary Model | Purpose | Tools |
|---|---|---|---|
| **main** (default) | Phi4-mini | Chat, coding, reasoning | Yes |
| **tcall** | Phi4-mini → Nanbeige → Gemini | Tool calling focus | Yes |

## Phi4-mini: Key Notes

Phi4-mini (Microsoft, 3.8B params, Q4_K_M) is the primary model because it supports **tool calling** and can do step-by-step reasoning in responses (not structured `/think` reasoning, but chain-of-thought in the response body).

\* Phi4-mini does not have structured `thinking` output like Qwen3-coder. Set `reasoning: false` in OpenClaw config to avoid issues. It can still reason — just inline in the response text.

### Aider Integration

Phi4-mini requires special flags for Aider:

```powershell
# Use the aphi launcher (flags included automatically)
aphi

# Or manually:
aider --raw-model --edit-format whole --model "ollama_chat/phi4-mini:3.8b-q4_K_M"
```

**Why `--raw-model --edit-format whole`?**
- `--raw-model` — bypasses Aider's model registry (phi4-mini is not in the default list)
- `--edit-format whole` — sends the entire file content instead of diffs (phi4-mini handles whole files better than diff format)

### OpenClaw / Pi Integration

No special flags needed. OpenClaw and Pi use the standard Ollama API:

```powershell
ocphi    # OpenClaw + Phi4-mini
piphi    # Pi + Phi4-mini
```

## VRAM Considerations (4GB GPU)

With a 4GB VRAM GPU (e.g., GTX 1650), only one model fits in VRAM at a time.

**Critical settings:**

```env
OLLAMA_KEEP_ALIVE=0              # Unload previous model immediately when swapping
OLLAMA_NUM_PARALLEL=1            # Only 1 concurrent request
OLLAMA_MAX_LOADED_MODELS=1       # Only 1 model in VRAM at a time
```

**Context window:** Set `contextWindow: 32768` (32K) for all local models. Do NOT use 262144 (256K, onboard default) — it requires 37GB+ RAM and will crash.

**Model load time:** First inference after a swap takes 2-10 seconds. Pre-warm with:

```bash
curl http://127.0.0.1:11434/api/generate -d '{"model":"phi4-mini:3.8b-q4_K_M","prompt":"hi","stream":false}'
```

## Launcher Commands

### All Agents

| Command | Agent | Model | Purpose |
|---|---|---|---|
| `aphi` | Aider | Phi4-mini | Reasoning (--raw-model --edit-format whole) |
| `ocphi` | OpenClaw | Phi4-mini | Reasoning + tool calling |
| `piphi` | Pi | Phi4-mini | Reasoning |
| `ocdev` | OpenClaw | Jan-code | Daily coding |
| `ocqcoder` | OpenClaw | Qwen3-coder | Fast code |
| `ocplan` | OpenClaw | Qwen3.5-opus | Heavy reasoning |
| `octool` | OpenClaw | Phi4-mini | Tool calling mode |
| `octeach` | OpenClaw | Jan-code + skills | Teaching assistant |
| `ocislami` | OpenClaw | Jan-code + skills | Islamic assistant |

### Telegram Model Switching

```
/models                                              # List all models
/model status                                        # Show active model
/model ollama/phi4-mini:3.8b-q4_K_M                  # Switch to Phi4-mini
/model ollama/aikid123/Qwen3-coder:latest             # Switch to Qwen3-coder
/model google/gemini-2.5-flash                        # Switch to Gemini (cloud)
/model ollama/softw8/Nanbeige4.1-3B-q4_K_M:latest     # Switch to Nanbeige
```

## Model Selection Guide

| Task | Recommended | Why |
|---|---|---|
| General chat + reasoning | Phi4-mini | Primary, reasoning + tools |
| Quick code Q&A | Qwen3-coder | Fastest, 1.4GB |
| Daily coding (multi-file) | Jan-code or Phi4-mini | Balanced |
| Architecture decisions | Qwen3.5-opus | Best local reasoning depth |
| Tool calling (shell, GitHub) | Phi4-mini or Nanbeige | Only models with tool support |
| Long context (>32K) | Gemini Flash (cloud) | 1M context window |
| Teaching materials | Phi4-mini or Jan-code | Good content generation |
| Debugging complex issues | Qwen3.5-opus or Gemini | Deep reasoning needed |

## Configuration Reference

```bash
# View current model config
openclaw config get agents.defaults.model

# Change primary model
openclaw config set agents.defaults.model.primary "ollama/phi4-mini:3.8b-q4_K_M"

# List all models OpenClaw can see
openclaw models list

# View agents and routing
openclaw agents list --bindings
```
