# Local GPU 4GB Setup

This is the fully documented reference setup in this repository.

## Environment

- OS: Windows 11
- GPU: NVIDIA GTX 1650 4GB
- Local runtime: Ollama on Windows
- Agent mix:
  - Aider on Windows
  - Hermes Agent in WSL
  - Pi on Windows

## Recommended Models

- `fredrezones55/Jan-code:Q4_K_M` -> daily coding default
- `aikid123/Qwen3-coder:latest` -> fast code and chat with thinking
- `fredrezones55/qwen3.5-opus:4b` -> complex thinking code and heavier work
- `relational/orlex:latest` -> backup reasoning and architecture
- `rardiolata/CodeTito:latest` -> backup coding model
- `codegemma:2b` -> autocomplete-oriented editor helper
- `nomic-embed-text:latest` -> embeddings only

## Why This Model Split

- Jan-code gives the best current balance for daily coding on 4GB-class hardware
- Aikid Qwen3-coder is a good fast code/chat model with thinking support
- Qwen3.5 Opus 4B is reserved for heavier complex reasoning and code work
- Orlex and CodeTito are backups, not first choices
- CodeGemma is better used for autocomplete than full agent workflows

## Agent Recommendations

### Aider

Use Aider as the main coding workflow.

Recommended commands:

- `adev`
- `asafe`
- `aqcoder`
- `aplan`
- `aheavy`
- `amodels`

### Hermes Agent

Use Hermes as a secondary workflow, especially when you want its interaction style or WSL-based environment.

Recommended commands:

- `hdev`
- `hsafe`
- `hqcoder`
- `hplan`
- `hheavy`
- `hmodels`

### Pi

Use Pi as a strong secondary coding harness.

Recommended commands:

- `pidev`
- `psafe`
- `pqcoder`
- `pplan`
- `pheavy`
- `pmodels`

## Installation Notes

The reference setup assumes:

- Python 3.12 on Windows for Aider
- WSL for Hermes Agent
- Node.js for Pi
- Git Bash available for Pi on Windows
- Ollama available locally at `http://127.0.0.1:11434`

## Public Templates

See:

- `templates/local-gpu-4gb/aider/`
- `templates/local-gpu-4gb/hermes/`
- `templates/local-gpu-4gb/pi/`
- `templates/local-gpu-4gb/scripts/`

## Practical Advice

- Start with Aider if you need direct Windows repo editing
- Keep Jan-code as the default until another model proves more reliable
- Treat multi-step CRUD requests carefully on local models and verify results
