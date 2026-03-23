# Update Workflow

This repository is the public-friendly version of your setup.

## Purpose

- document what works
- share reusable templates
- provide a clean structure for contributors
- avoid leaking private machine state

## Normal Update Flow

1. Change and validate the live setup on your machine.
2. Update the private backup repository first.
3. Refresh the public repository templates from the live setup.
4. Edit documentation if the workflow, model strategy, or commands changed.
5. Commit public-safe changes.

## Command

From this repository root, run:

```powershell
powershell -ExecutionPolicy Bypass -File .\scripts\refresh-public-templates.ps1
```

## What Gets Refreshed

- safe Aider config templates
- safe Hermes config and persona templates
- safe Pi config templates
- selected launcher examples

## What You Still Review Manually

- README wording
- installation guides
- model recommendations
- contribution notes

## Good Rule

Private repo first, public repo second.
