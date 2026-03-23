# Full Setup AI Agents

![Windows](https://img.shields.io/badge/platform-Windows%2011-0078D6?style=flat-square)
![Ollama](https://img.shields.io/badge/runtime-Ollama-111111?style=flat-square)
![Agents](https://img.shields.io/badge/agents-Aider%20%7C%20Hermes%20%7C%20Pi-4B5563?style=flat-square)
![Focus](https://img.shields.io/badge/focus-Local%20AI%20Engineering-0F766E?style=flat-square)

Practical setup guides, reusable templates, and sync workflows for running local AI coding agents with Ollama.

This repository focuses on three agents:
- Aider
- Hermes Agent
- Pi Coding Agent

It is built for people who want a real local workflow for create, read, update, and delete tasks on actual project files, not just chat demos.

## Why This Repository Exists

Most AI-agent setup notes are either:
- too generic to reproduce
- too personal to reuse
- too fragile to maintain

This repository tries to be more useful:
- real-world setup patterns
- model-role mapping that matches actual hardware limits
- public-safe templates
- sync workflows for keeping docs aligned with a tested local setup
- a contribution-friendly structure for people who want to share their own setups

## Who This Repository Is For

- Fullstack developers
- IT generalists
- Local-first AI users
- Windows users with low-VRAM GPUs
- People who want to back up and version their agent configuration cleanly

## Supported Agents

| Agent | Best Use In This Repo |
|---|---|
| Aider | Primary Windows-native repo editing |
| Hermes Agent | Secondary workflow, planning, WSL-based usage |
| Pi | Lean customizable coding harness |

## Supported Environments

- `local-gpu-4gb` - fully documented from a real working setup
- `local-cpu-only` - recommended setup path using NovaforgeAI models

## Current Local GPU 4GB Model Strategy

- `fredrezones55/Jan-code:Q4_K_M` -> daily coding default
- `relational/orlex:latest` -> planning, architecture, reasoning
- `fredrezones55/qwen3.5-opus:4b` -> heavier mixed fallback
- `nomic-embed-text:latest` -> embeddings only, not for chat/coding

## Environment Comparison

| Environment | Status | Best Default | Notes |
|---|---|---|---|
| Local GPU 4GB | Tested | `fredrezones55/Jan-code:Q4_K_M` | Best current practical reference |
| Local CPU Only | Recommended | NovaforgeAI small models or API-backed providers | Good contribution target for future validation |

## Quick Start

- Read `docs/quick-start.md`
- For the tested setup, start with `docs/installation/local-gpu-4gb.md`
- For the lighter CPU-oriented path, read `docs/installation/local-cpu-only.md`

## Repository Structure

```text
docs/       -> setup guides, operations, troubleshooting, contribution notes
templates/  -> reusable public-safe config templates by environment
guides/     -> quick command references
scripts/    -> sync helpers for keeping repo templates aligned with local setup
assets/     -> screenshots and images
```

## Documentation Map

- `docs/overview.md`
- `docs/quick-start.md`
- `docs/installation/local-gpu-4gb.md`
- `docs/installation/local-cpu-only.md`
- `docs/agents/aider.md`
- `docs/agents/hermes-agent.md`
- `docs/agents/pi-agent.md`
- `docs/models/model-strategy.md`
- `docs/models/novaforgeai-cpu-only.md`
- `docs/models/cpu-only-provider-strategy.md`
- `docs/operations/backup-and-restore.md`
- `docs/operations/update-workflow.md`
- `docs/operations/contributor-sync-guide.md`
- `docs/operations/troubleshooting.md`
- `docs/operations/security.md`
- `docs/contribution-guide.md`

## Why Back Up Agent Configs at All?

If you use Aider, Hermes, Pi, Ollama, custom launchers, and local model routing, your setup becomes part of your engineering environment.

Backing it up gives you:
- a faster restore path on a new machine
- versioned changes to prompts, configs, and launchers
- cleaner experimentation with different models
- easier sharing of sanitized setups with other people

## Public Repo vs Private Repo

This project works best with two repositories:

- public repo -> reusable docs, templates, contributor-friendly structure
- private repo -> your live working backup and machine-specific copies

Recommended rule:
- private repo first
- public repo second

## Keeping the Repository in Sync With a Local Setup

This repository is designed to be updated from a real local working setup.

Recommended order:

1. update and validate the local machine setup
2. sync the private backup repository
3. refresh the public templates
4. update the docs if commands or model strategy changed

Useful scripts:

```powershell
# from the public repo
powershell -ExecutionPolicy Bypass -File .\scripts\sync-all.ps1

# or run the public step only
powershell -ExecutionPolicy Bypass -File .\scripts\refresh-public-templates.ps1
```

For more detail, read:

- `docs/operations/update-workflow.md`
- `docs/operations/contributor-sync-guide.md`

## Share Your Setup

This repository is intentionally structured so other people can contribute their own working AI-agent setups.

Useful contributions include:
- cloud VPS without GPU
- Linux desktop
- macOS
- larger local GPU setups
- better CPU-only model recommendations
- alternative local model families
- different launcher strategies

If you maintain your own agent stack, consider contributing:
- sanitized config templates
- documented model choices
- launcher patterns
- hardware notes
- troubleshooting notes

The goal is simple: make it easier for other people to back up, understand, and share agent setups that actually work.

If your setup differs from this one, that is a feature, not a problem.
Different hardware tiers, operating systems, model families, and launcher strategies are all useful contributions when they are documented clearly.

## Contributing

Contributions are welcome.

See `docs/contribution-guide.md` for the preferred direction and `docs/operations/contributor-sync-guide.md` for the sync/update workflow.

Good contribution examples:
- a tested CPU-only setup with measured tradeoffs
- a Linux-native workflow
- a cloud VPS no-GPU workflow
- a cleaner launcher design
- better restore or troubleshooting notes

## Security Notes

- Do not commit real API keys, auth files, or session state
- Treat these templates as public-safe examples unless explicitly marked as private backup material
- Review all launcher scripts before running them on production machines

## License

MIT
