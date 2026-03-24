# Continue.dev

Continue.dev is a useful companion in this repository's ecosystem even though it is not used as the primary standalone agent runner.

## Why It Fits Well

- editor-native workflow
- practical chat panel for code questions
- inline assistance and autocomplete support
- easy pairing with Ollama models

## Recommended Role Split

- `aikid123/Qwen3-coder:latest` -> chat and fast code help
- `fredrezones55/Jan-code:Q4_K_M` -> daily coding chat
- `fredrezones55/qwen3.5-opus:4b` -> heavier thinking and image-capable experiments
- `codegemma:2b` -> tab autocomplete
- `nomic-embed-text:latest` -> embeddings

## Example Config

See:

- `templates/local-gpu-4gb/continue-dev/config.json`

This template reflects the current working role split:

- Qwen3-coder for fast chat/code
- Jan-code for daily coding
- CodeTito and Orlex as backups
- Qwen3.5 Opus for heavier thinking
- CodeGemma for tab autocomplete
- Nomic Embed Text for embeddings

## Practical Position In The Stack

Use Continue.dev when you want editor-native assistance.

Use Aider, Hermes, or Pi when you want a more explicit agent or terminal-driven workflow.
