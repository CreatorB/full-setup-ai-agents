# Contributor Sync Guide

This guide explains how to keep a local working setup aligned with the repository templates and documentation.

## Who This Is For

- people contributing a new environment setup
- people improving an existing setup after testing changes locally
- maintainers who want a repeatable way to refresh templates from a working machine

## Basic Rule

Make changes locally first. Only update the repository after the local setup is tested.

## Recommended Flow

1. Update the live local setup on your machine.
2. Verify that the agent, model, and launcher changes actually work.
3. Refresh the repository templates from the working local setup.
4. Update the docs if commands, models, paths, or workflow changed.
5. Commit only public-safe files.

## Current Repository Workflow

For the current maintainer workflow, there are two repositories:

- private backup repo -> exact working setup backup
- public repo -> reusable templates and documentation

### Private Backup First

Run this from the private repo:

```powershell
powershell -ExecutionPolicy Bypass -File .\scripts\sync-from-local.ps1
```

### Public Templates Second

Run this from the public repo:

```powershell
powershell -ExecutionPolicy Bypass -File .\scripts\refresh-public-templates.ps1
```

### One-Command Option

Run this from the public repo:

```powershell
powershell -ExecutionPolicy Bypass -File .\scripts\sync-all.ps1
```

## Before Opening a Pull Request

Check these quickly:

- your local setup actually works
- docs reflect the current commands and models
- templates are sanitized
- no secret files are included
- tested vs recommended status is clearly stated

## What Should Be Synced

- agent config templates
- safe launcher examples
- non-secret instruction files
- public-safe defaults and model mappings

## What Should Be Edited Manually After Sync

- README sections
- installation guides
- troubleshooting notes
- model recommendations
- contributor notes

## What Must Not Be Committed

- API keys
- auth files
- session logs
- caches
- machine-private state files

## Contribution Advice

If you add a new environment:

- place docs under `docs/installation/`
- place templates under `templates/<environment>/`
- clearly mark whether the setup is tested or only recommended
- explain tradeoffs and hardware assumptions
- if you changed a live setup first, run the sync workflow before opening a PR
