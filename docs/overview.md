# Overview

This repository documents a local AI agent stack built around Ollama and three different coding agents.

## Design Goals

- Make local AI agents useful for real engineering work
- Support file CRUD, refactoring, and project navigation
- Keep setup understandable and reproducible
- Work well on lower-end hardware where possible

## Agent Roles

- **Aider** is the primary Windows-native editing workflow
- **Hermes Agent** is a flexible WSL-based assistant with a richer agent shell
- **Pi** is a lean coding harness with strong customization potential

## Adjacent Tooling Worth Knowing

- **OpenCode** can be a strong hosted coding companion when local models are not enough
- **Continue.dev** is a practical editor integration layer for chat, autocomplete, and local model usage
- **Zed IDE** is worth testing if you want an AI-friendly editor with a different workflow style
- **Context7** is useful when you want an agent to fetch fresher library and framework documentation context
- **build.nvidia.com** is worth watching for hosted experimentation and model access options

## Environment Philosophy

The repository uses environment folders and environment-specific docs rather than separate branches.

That makes it easier to:

- index in search engines
- compare setups side by side
- keep shared docs in one place
- accept contributions from other users

## Current Coverage

- tested: local GPU 4GB setup on Windows with Ollama
- recommended path: local CPU-only using smaller NovaforgeAI-oriented model selection

## Future Community Value

The project is intentionally structured so other users can add:

- cloud VPS setups
- Linux-native flows
- larger GPU setups
- different model families
- better automation and operational hardening
