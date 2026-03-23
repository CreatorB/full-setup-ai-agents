# Contribution Guide

Contributions are welcome.

This repository is meant to become a practical reference for different AI agent setups, not just one machine.

## A Good Contribution Mindset

Contribute the setup you wish you had found earlier:

- clear
- reproducible
- honest about hardware limits
- safe to publish
- useful to someone who is not using your exact machine

## Good Contribution Areas

- cloud VPS without GPU
- Linux desktop setups
- macOS setups
- better CPU-only model recommendations
- better Windows troubleshooting notes
- additional launcher patterns
- benchmark notes for different hardware tiers
- public-safe backup workflows
- sanitized agent config collections

## Preferred Contribution Style

- keep documentation concrete and reproducible
- clearly separate tested setups from recommended-but-not-validated setups
- avoid committing secrets, auth files, and session state
- explain tradeoffs, not just commands
- prefer templates and examples that other people can actually reuse

## What Makes a Good Setup Guide

- environment description
- hardware assumptions
- model selection rationale
- installation steps
- launcher examples
- known limitations
- troubleshooting notes

## Sharing Your Own Configs

If you want to share your own setup, prefer this pattern:

- keep your exact live backup in a private repository
- contribute a sanitized public-safe version here

Good shared content:

- model config templates
- launcher examples
- AGENTS or instruction files without private data
- restore notes without secrets
- workflow notes about what worked and what failed

Do not share:

- API keys
- auth files
- private session history
- machine-specific secrets
- anything you would not want indexed publicly

## Suggested Sharing Pattern

The cleanest way to contribute is:

1. keep your exact machine backup private
2. extract the reusable parts
3. sanitize paths, tokens, and machine-only details
4. contribute the public-safe templates and docs here

That way the repository stays useful to other people instead of becoming a dump of private machine state.

## Suggested Contribution Layout

- docs in `docs/installation/`
- templates in `templates/<environment>/`
- reusable command references in `guides/`

## If You Update From a Real Local Setup

Use the sync workflow documented in:

- `docs/operations/contributor-sync-guide.md`

That keeps the repository aligned with a tested local machine instead of becoming stale documentation.

## What Makes a Contribution Interesting

Contributions become especially valuable when they include:

- hardware constraints
- why a model was chosen
- where the setup fails or struggles
- what launcher pattern made daily use easier
- what other people should avoid
