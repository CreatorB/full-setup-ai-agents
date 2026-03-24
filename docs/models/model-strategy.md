# Model Strategy

This repository uses role-based model selection instead of one-model-for-everything.

## Current Roles

- `fredrezones55/Jan-code:Q4_K_M` -> best daily coding default
- `aikid123/Qwen3-coder:latest` -> fast code and chat with thinking
- `fredrezones55/qwen3.5-opus:4b` -> complex thinking code and heavier work
- `relational/orlex:latest` -> backup reasoning, planning, architecture
- `rardiolata/CodeTito:latest` -> backup coding model
- `codegemma:2b` -> autocomplete-oriented editor model
- `nomic-embed-text:latest` -> embeddings only

## Why This Works Better

- coding and planning do not always need the same model behavior
- lower-VRAM hardware benefits from clear defaults
- agent quality improves when model choice matches task type

## Default Rule

Start with Jan-code unless you have a clear reason not to.

Use Aikid Qwen3-coder when you want faster coding chat with built-in thinking.

Use Qwen3.5 Opus 4B when you need heavier thinking or more complex code reasoning.
