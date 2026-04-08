# BTCPay Server Installer

A guided, conversational skill for deploying BTCPay Server via Docker. No prior Bitcoin or server knowledge needed.

## What This Does

Deploys a fully functional BTCPay Server on your own Linux server with:
- Your own Bitcoin full node
- TOR access (works immediately, no DNS needed)
- Auto-configured HTTPS via Let's Encrypt
- Optional Lightning Network support

## What You Need

- A Linux server (Ubuntu 20.04+ or Debian 11+)
- SSH access to that server
- At least 100GB disk space
- A domain name (optional — TOR works without it)
- Ports 80 and 443 open

## Quick Start

1. Load the skill: `hermes skills install btcpay-server-install`
2. Trigger it: `Install BTCPay Server`
3. Answer the questions — I'll handle the rest

## For Developers

### Repository Structure

```
btcpay-server-install/
├── SKILL.md              # Main skill file — conversational guide
├── README.md             # This file
├── scripts/
│   ├── deploy.sh         # Deployment script (runs on your server)
│   └── btcpay-helpers.sh # Post-deploy management commands
└── references/           # (optional) additional docs
```

### How the Skill Works

The skill runs in two phases:

**Phase 1 — Guided setup**
Walks the user through 5 questions to configure their BTCPay Server. No technical knowledge required.

**Phase 2 — Deployment**
Runs `deploy.sh` on their server. The script:
1. Auto-detects the server's public IP
2. Installs Docker (if not already installed)
3. Clones or updates the BTCPay Docker repository
4. Configures environment variables based on answers
5. Starts all containers and verifies deployment

**Phase 3 — Post-deploy management**
User runs `btcpay-helpers.sh` for日常 management tasks.

### Configuration Options

Pass these as environment variables when running `deploy.sh`:

| Variable | Default | Options | Description |
|---|---|---|---|
| `BTCPAY_HOST` | *(empty)* | domain.com | Your domain. Leave empty for TOR only. |
| `NBITCOIN_NETWORK` | `mainnet` | mainnet, testnet, regtest | Bitcoin network |
| `LIGHTNING` | `none` | lnd, clightning, eclair, none | Lightning implementation |
| `PRUNE` | `100` | 5, 25, 50, 100 | Pruning size in GB |

Example:
```bash
BTCPAY_HOST="btcpay.mysite.com" \
LIGHTNING="lnd" \
PRUNE="100" \
bash deploy.sh
```

### Pruning Reference

| Size | History | Notes |
|---|---|---|
| 100GB | ~1 year | Recommended for most users |
| 50GB | ~6 months | |
| 25GB | ~3 months | Minimum for Lightning Network |
| 5GB | ~2 weeks | Testing only |
| 0 | Full blockchain | ~600GB+ required |

### Management Commands

After deployment, these are available on your server:

```bash
bash btcpay-helpers.sh status    # Check if everything is running
bash btcpay-helpers.sh tor       # Get your TOR link
bash btcpay-helpers.sh btc      # Bitcoin sync status
bash btcpay-helpers.sh logs     # View BTCPay logs
bash btcpay-helpers.sh restart  # Restart everything
bash btcpay-helpers.sh stop     # Stop BTCPay
bash btcpay-helpers.sh start    # Start BTCPay
```

### Changing Settings After Deployment

```bash
cd /root/btcpayserver-docker && . btcpay-down.sh
nano /root/.env              # edit your settings
cd /root/btcpayserver-docker && . btcpay-setup.sh -i
```

Blockchain data survives restarts. You rarely need a full re-install.

### Uninstalling

```bash
cd /root/btcpayserver-docker && . btcpay-down.sh
rm -rf /root/btcpayserver-docker
rm -f /root/.env /etc/profile.d/btcpay-env.sh
docker volume ls | grep generated | awk '{print $2}' | xargs -r docker volume rm
```

## Troubleshooting

**BTCPay shows 503 on my domain**
DNS hasn't propagated yet. Use the TOR link — it works immediately.

**Bitcoin RPC not responding after deployment**
Normal — RPC comes online after blockheaders finish downloading. Wait 5-10 minutes and try again.

**Port 80/443 already in use**
Stop any existing services on those ports before deploying.

**Deployment fails on a fresh server**
Make sure ports 80 and 443 are open in both your cloud firewall AND local UFW.

## Contributing

This skill is designed to be simple and accessible for non-technical users. If you have suggestions:
- Open an issue describing what was confusing or missing
- PRs welcome — especially for improving clarity and accuracy

## Credits

- [BTCPay Server](https://btcpayserver.org/) — the software we're deploying
- [BTCPay Server Docker](https://github.com/btcpayserver/btcpayserver-docker) — the deployment system
