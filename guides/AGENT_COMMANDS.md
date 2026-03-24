# Agent Commands

Unified quick reference for three local coding agents on Windows.

## Daily Coding

- Aider: `adev`
- Hermes: `hdev`
- Pi: `pidev`

## Fast Code / Chat With Thinking

- Aider: `aqcoder`
- Hermes: `hqcoder`
- Pi: `pqcoder`

## Lower-Risk Daily Coding

- Aider: `asafe`
- Hermes: `hsafe`
- Pi: `psafe`

## Complex Thinking / Code

- Aider: `aplan`
- Hermes: `hplan`
- Pi: `pplan`

## Heavier Fallback

- Aider: `aheavy`
- Hermes: `hheavy`
- Pi: `pheavy`

## Backup Models

- Aider: `aorlex`, `atito`
- Hermes: `horlex`, `htito`
- Pi: `piorlex`, `ptito`

## Flexible Model Switching

- Aider: `amodel <model> [path]`
- Hermes: `hmodel <model> [path]`
- Pi: `pmodel <model> [path]`

## Instant Model Try Examples

```powershell
amodel --raw-model --edit-format whole "ollama_chat/rardiolata/CodeTito"
hmodel "rardiolata/CodeTito:latest"
pmodel "rardiolata/CodeTito:latest"
```

Notes:

- `amodel` sometimes needs `--raw-model` when you want a provider-prefixed Aider model route like `ollama_chat/...`
- `hmodel` and `pmodel` already use the exact Ollama model name directly, so no raw-model flag is needed there
