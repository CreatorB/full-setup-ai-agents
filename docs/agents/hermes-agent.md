# Hermes Agent

Hermes Agent runs in WSL in the documented reference setup.

## Strengths

- flexible agent shell
- good for structured exploration and multi-step reasoning
- rich environment for future extensions

## Limitations

- local model obedience varies more than with Aider
- file CRUD reliability depends heavily on the selected model
- WSL adds another layer compared to direct Windows-native editing

## Recommended Commands

- `hdev`
- `hsafe`
- `hqcoder`
- `hplan`
- `hheavy`
- `htito`
- `hmodels`
- `hmodel <model> [path]`

## Best Use Cases

- planning and architecture
- WSL-based workflows
- secondary coding assistant usage
- controlled experiments with different local models

## Current Model Role Mapping

- Jan-code -> daily coding default
- Aikid Qwen3-coder -> fast code and chat with thinking
- Qwen3.5 Opus 4B -> complex thinking code and heavier work
- Orlex and CodeTito -> backup models
