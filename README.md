# BTCPay Server Installer — AI Agent Skill

An AI agent skill for deploying BTCPay Server via Docker. Designed for non-technical users — the agent handles everything, the user just answers questions.

---

## For AI Agent Users

### Hermes Agent

```bash
# Install the skill
curl -sSL https://raw.githubusercontent.com/welliv/btcpay-server-install/main/install-hermes.sh | bash

# Then say to Hermes:
# "Install BTCPay Server"
```

### Claude Code / Claude Desktop

Add to your `~/.claude/projects/*/instructions` or global settings:

```
You have access to the btcpay-server-install skill. When the user says to install BTCPay Server, read the skill from ~/.hermes/skills/btcpay-server-install/SKILL.md and follow the guided setup.
```

Or via the skill manager:
```bash
skill install https://github.com/welliv/btcpay-server-install
```

### Other AI Agents

Clone the repo and adapt the `SKILL.md` to your agent's skill format:

```bash
git clone https://github.com/welliv/btcpay-server-install
```

---

## What the Skill Does

The agent walks the user through 5 simple questions:

1. **Domain** — Do you have one? (TOR works without DNS)
2. **Network** — Mainnet or Testnet?
3. **Storage** — How much disk for Bitcoin? (100GB, 50GB, 25GB, 5GB)
4. **Lightning** — Yes or no?
5. **Ready** — Confirm and deploy

The agent then runs `deploy.sh` on the user's server and verifies everything is working.

---

## What Gets Installed

| Component | Description |
|---|---|
| **BTCPay Server** | Payment processor |
| **Bitcoin Node** | Validates transactions independently |
| **TOR** | Private access link — works immediately |
| **Let's Encrypt** | Auto-configured HTTPS |
| **PostgreSQL** | Database |
| **Nginx** | Web server |

Bitcoin sync runs in background — takes 1–3 days. Server is ready to use right away.

---

## Requirements

| Requirement | Details |
|---|---|
| **OS** | Ubuntu 20.04+ or Debian 11+ |
| **Disk** | At least 100GB free |
| **Ports** | 80 and 443 open |
| **Access** | SSH to the server |

---

## Configuration

Default values can be overridden:

| Variable | Default | Options |
|---|---|---|
| `BTCPAY_HOST` | *(TOR only)* | Your domain |
| `NBITCOIN_NETWORK` | `mainnet` | `mainnet`, `testnet`, `regtest` |
| `LIGHTNING` | `none` | `lnd`, `clightning`, `eclair`, `none` |
| `PRUNE` | `100` | `5`, `25`, `50`, `100` (GB) |

**Pruning reference:**

| Size | History |
|---|---|
| 100GB | ~1 year |
| 50GB | ~6 months |
| 25GB | ~3 months (minimum for Lightning) |
| 5GB | ~2 weeks (testing only) |

---

## After Deployment

The skill shows the user two access links:

- **🧅 TOR** — works immediately
- **🌐 Domain** — works once DNS propagates

Post-deploy management via `btcpay-helpers.sh`:
```bash
btcpay-helpers.sh status    # Check if everything is running
btcpay-helpers.sh tor        # Get TOR link
btcpay-helpers.sh btc       # Bitcoin sync status
btcpay-helpers.sh logs      # View BTCPay logs
btcpay-helpers.sh restart   # Restart everything
```

---

## Repo Structure

```
btcpay-server-install/
├── SKILL.md               — AI agent skill (primary)
├── README.md              — This file
├── LICENSE               — MIT
├── CHANGELOG.md          — version history
├── CONTRIBUTING.md       — how to contribute
├── SECURITY.md           — vulnerability disclosure
├── .github/
│   ├── workflows/ci.yml   — shellcheck + markdown lint
│   ├── ISSUE_TEMPLATE/    — bug + feature templates
│   └── pull_request_template.md
├── scripts/
│   ├── deploy.sh          — deployment script (called by skill)
│   └── btcpay-helpers.sh  — post-deploy management
└── install-hermes.sh      — Hermes skill installer
```

---

## Contributing

Found an issue? Open a bug report or feature request. PRs welcome — see `CONTRIBUTING.md`.

---

## License

MIT
