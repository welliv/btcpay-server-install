# Changelog

All notable changes to this project will be documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.0.0/).

## [1.0.0] — 2025-04-08

### Added
- Initial release — AI Agent Skill for BTCPay Server deployment
- `SKILL.md` — Conversational 5-step guided setup for AI agents and non-technical users
- `scripts/deploy.sh` — Auto-detecting, idempotent deployment script
- `scripts/btcpay-helpers.sh` — Post-deploy management commands
- `references/quick-reference.md` — Agent-facing quick reference card
- `install-hermes.sh` — Hermes Agent skill installer
- MIT License, CHANGELOG, CONTRIBUTING, SECURITY, CI, issue/PR templates

### Core Features
- Auto-detects public IP — no hardcoded values
- Checks Docker before installing — handles existing setups
- Git pull for repo updates — idempotent on re-run
- Dynamic container name detection — no hardcoded container IDs
- Color-coded helper output
- TOR link generation on first deploy
- Bitcoin node sync status via `btcpay-helpers.sh btc`
- Shellcheck clean on all scripts

### Skill Features
- Domain + TOR or TOR-only deployment
- Mainnet, Testnet, Regtest network options
- LND, C-Lightning, Eclair, or no Lightning
- 5GB, 25GB, 50GB, 100GB pruning options
- Step-by-step verification after deployment
- Post-deploy change guidance
- Full uninstall instructions

### Repositioned
- [2025-04-08] v1.0 — Reframed as AI Agent skill (Hermes, Claude, etc.) as primary product. BTCPay community deploy script is secondary.
