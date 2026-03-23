# Backup and Restore

This repository is intended to work well alongside a separate private backup repository.

## Recommended Split

- public repo -> sanitized templates and documentation
- private repo -> machine-specific backups and live config copies

## What to Keep Public

- templates
- launcher examples
- setup guides
- model strategy docs

## What to Keep Private

- real personal config backups
- local machine notes
- any auth or state files

## Restore Mindset

When moving to a new machine:

1. restore Ollama and the chosen models
2. restore the agent templates
3. restore launcher scripts
4. verify paths and shell dependencies
5. run a small smoke test before trusting larger tasks
