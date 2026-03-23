# Model Strategy

This repository uses role-based model selection instead of one-model-for-everything.

## Current Roles

- `fredrezones55/Jan-code:Q4_K_M` -> best daily coding default
- `relational/orlex:latest` -> planning, reasoning, architecture
- `fredrezones55/qwen3.5-opus:4b` -> heavier mixed fallback
- `nomic-embed-text:latest` -> embeddings only

## Why This Works Better

- coding and planning do not always need the same model behavior
- lower-VRAM hardware benefits from clear defaults
- agent quality improves when model choice matches task type

## Default Rule

Start with Jan-code unless you have a clear reason not to.
