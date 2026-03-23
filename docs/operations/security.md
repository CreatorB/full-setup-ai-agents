# Security

## Do Not Commit

- API keys
- auth files
- agent session state
- cache and logs
- private `.env` files

## Review Before Running

- launcher scripts
- shell commands
- WSL path conversions
- anything that modifies production infrastructure

## General Rule

Treat public templates as examples, not blind copy-paste targets for production systems.
