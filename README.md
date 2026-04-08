# BTCPay Server Installer

Deploy BTCPay Server on your own Linux server — no technical knowledge needed.

One command. Everything configured. Up and running in ~10 minutes.

---

## Quick Start

SSH into your server and run:

```bash
curl -sSL https://raw.githubusercontent.com/welliv/btcpay-server-install/main/scripts/deploy.sh | bash
```

Answer the questions. Let it run. Your server is ready in ~10 minutes.

That's it.

---

## What Gets Installed

| Component | What it is |
|---|---|
| **BTCPay Server** | Your payment processor |
| **Bitcoin Node** | Validates transactions independently |
| **TOR** | Private access link — works immediately |
| **Let's Encrypt** | Auto-configured HTTPS |
| **PostgreSQL** | Database |
| **Nginx** | Web server |

**Bitcoin sync runs in background** — takes 1–3 days. Your server is ready to use right away.

---

## What You Need

| Requirement | Details |
|---|---|
| **OS** | Ubuntu 20.04+ or Debian 11+ |
| **Disk** | At least 100GB free |
| **Ports** | 80 and 443 open |
| **Domain** | Optional — TOR works without it |

---

## Configuration Options

Override defaults with environment variables:

```bash
# Example: domain + Lightning + 100GB prune
BTCPAY_HOST="btcpay.mysite.com" \
LIGHTNING="lnd" \
PRUNE="100" \
curl -sSL https://raw.githubusercontent.com/welliv/btcpay-server-install/main/scripts/deploy.sh | bash
```

| Variable | Default | Options |
|---|---|---|
| `BTCPAY_HOST` | *(TOR only)* | Your domain |
| `NBITCOIN_NETWORK` | `mainnet` | `mainnet`, `testnet`, `regtest` |
| `LIGHTNING` | `none` | `lnd`, `clightning`, `eclair`, `none` |
| `PRUNE` | `100` | `5`, `25`, `50`, `100` (GB) |

**Pruning reference:**

| Size | History | Notes |
|---|---|---|
| 100GB | ~1 year | Recommended for most users |
| 50GB | ~6 months | |
| 25GB | ~3 months | Minimum for Lightning Network |
| 5GB | ~2 weeks | Testing only |

---

## After Deployment

The script shows you two access links:

**🧅 TOR** *(works immediately)*
```
http://your-tor-address.onion
```

**🌐 Your domain** *(works once DNS propagates)*
```
https://btcpay.yoursite.com
```

Visit the TOR link and register your account.

---

## Management Commands

On your server, these are available:

```bash
btcpay-helpers.sh status    # Check if everything is running
btcpay-helpers.sh tor        # Get your TOR link
btcpay-helpers.sh btc       # Bitcoin sync status
btcpay-helpers.sh logs      # View BTCPay logs
btcpay-helpers.sh restart   # Restart everything
btcpay-helpers.sh stop      # Stop BTCPay
btcpay-helpers.sh start     # Start BTCPay
```

To copy helpers to your path:
```bash
sudo cp /root/btcpay-helpers.sh /usr/local/bin/
```

---

## Changing Settings Later

```bash
cd /root/btcpayserver-docker && . btcpay-down.sh
nano /root/.env    # edit your settings
cd /root/btcpayserver-docker && . btcpay-setup.sh -i
```

Blockchain data survives restarts. Rarely need a full re-install.

---

## Uninstalling

```bash
cd /root/btcpayserver-docker && . btcpay-down.sh
rm -rf /root/btcpayserver-docker
rm -f /root/.env /etc/profile.d/btcpay-env.sh
docker volume ls | grep generated | awk '{print $2}' | xargs -r docker volume rm
```

---

## Common Issues

**"Domain shows 503 error"**
DNS hasn't propagated. Use the TOR link — it works immediately.

**"Bitcoin RPC not responding"**
Normal right after deployment. RPC comes online after blockheaders finish downloading. Wait 5-10 minutes.

**"Port 80/443 already in use"**
Stop the existing service first: `systemctl stop nginx` or `systemctl stop apache2`

---

## For Hermes Agent Users

If you use [Hermes Agent](https://github.com/NousResearch/hermes-agent), this comes as a skill:

```bash
# Install the skill
curl -sSL https://raw.githubusercontent.com/welliv/btcpay-server-install/main/install-hermes.sh | bash

# Then in Hermes, say:
# "Install BTCPay Server"
```

The skill guides you through the same setup — one question at a time, conversational.

---

## Contributing

Issues and PRs welcome. This is a community tool — if something was confusing or broke, open an issue.

---

## License

MIT — do whatever you want with it.
