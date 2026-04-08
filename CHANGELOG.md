# Changelog

All notable changes to this project will be documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.0.0/).

## [1.0.0] — 2025-04-08

### Added
- Initial release
- `SKILL.md` — conversational 5-step guided setup for non-technical users
- `scripts/deploy.sh` — auto-detecting, idempotent deployment script
- `scripts/btcpay-helpers.sh` — post-deploy management commands
- MIT License
- README focused on BTCPay community
- Contributing guide

### Features
- Auto-detects public IP
- Checks Docker installation before attempting install
- Handles git pull for existing repo updates
- Dynamic container name detection (no hardcoded container IDs)
- Color-coded helper output
- TOR link generation
- Bitcoin node sync status via `btcpay-helpers.sh btc`

### Configuration
- Domain + TOR or TOR-only deployment
- Mainnet, Testnet, Regtest networks
- LND, C-Lightning, Eclair, or no Lightning
- 5GB, 25GB, 50GB, 100GB pruning options
