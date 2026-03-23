# Troubleshooting

## Ollama Model Not Found

- run `ollama list`
- confirm the model name matches the launcher or config exactly

## Windows PATH Issues

- reopen the terminal after updating PATH
- verify that `aider`, `pi`, and your launcher scripts are on PATH

## Hermes WSL Issues

- verify WSL is running
- verify Hermes can reach Windows Ollama through `host.docker.internal`

## Model Loads but Behaves Badly

- this is often a model-quality problem, not a launcher problem
- switch to the safer default first
- use task-specific aliases instead of forcing a weak model

## CRUD Tasks Stop Halfway

- this happens with some local models
- verify file state manually
- prefer the safest default model for important edits
