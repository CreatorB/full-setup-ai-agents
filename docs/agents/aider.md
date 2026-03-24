# Aider

Aider is the primary editing workflow in this repository.

## Why Aider Is First

- it works directly on Windows repos in this setup
- it fits CRUD and refactoring tasks naturally
- it is the strongest current choice for practical file editing on the documented machine

## Recommended Commands

- `adev`
- `asafe`
- `aqcoder`
- `aplan`
- `aheavy`
- `atito`
- `amodels`
- `amodel <model> [path]`

## Raw Model Override Tip

Some models behave better with a different provider route or explicit edit settings.

Examples:

```powershell
amodel "aikid123/Qwen3-coder:latest"
amodel --edit-format whole "rardiolata/CodeTito:latest"
amodel --raw-model --edit-format whole "ollama_chat/rardiolata/CodeTito"
amodel --raw-model --editor-model "ollama/aikid123/Qwen3-coder:latest" "ollama_chat/rardiolata/CodeTito"
```

Use `--raw-model` when you want to pass a full provider-prefixed model string without Aider automatically prepending `ollama/`.

## Model Role Mapping

- Jan-code -> default coding profile
- Aikid Qwen3-coder -> fast code and chat with thinking
- Qwen3.5 Opus 4B -> complex thinking code and heavier fallback
- Orlex -> backup reasoning/planning profile
- CodeTito -> backup coding profile
- CodeGemma -> autocomplete-oriented editor model

## Best Use Cases

- direct file editing
- repo-local CRUD work
- refactoring
- implementation follow-through after a plan is ready
