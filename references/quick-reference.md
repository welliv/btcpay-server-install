# Agent Quick Reference

## Skill Trigger
- **Trigger phrase:** "Install BTCPay Server"
- **Skill path:** `~/.hermes/skills/btcpay-server-install/SKILL.md`

## What This Skill Does
Deploys BTCPay Server on the user's Linux server via Docker. The agent handles everything — user just answers 5 questions.

## Conversation Flow
1. Ask: Do you have a domain? (yes/skip)
2. Ask: Mainnet or Testnet? (mainnet/testnet)
3. Ask: Disk space for Bitcoin? (100GB/50GB/25GB/5GB)
4. Ask: Lightning Network? (yes/no)
5. Ask: Ready to deploy? (deploy)
6. Run `deploy.sh` with the user's answers
7. Show the TOR link and domain link
8. Verify all containers are up

## Deployment Command
```bash
cd ~/.hermes/skills/btcpay-server-install/scripts
BTCPAY_HOST="domain.com" \
LIGHTNING="lnd" \
PRUNE="100" \
bash deploy.sh
```

## Post-Deploy Commands
```bash
btcpay-helpers.sh status    # container status
btcpay-helpers.sh tor        # get TOR link
btcpay-helpers.sh btc       # Bitcoin sync info
btcpay-helpers.sh logs      # BTCPay logs
btcpay-helpers.sh restart   # restart everything
```

## Common User Questions

| User says | What to do |
|---|---|
| "My domain shows 503" | DNS not propagated. Use TOR link. |
| "How long does sync take?" | 1-3 days. Runs in background. |
| "I picked the wrong setting" | Edit `/root/.env`, then `btcpay-setup.sh -i` |
| "How do I check status?" | `btcpay-helpers.sh status` |
| "Where's my TOR link?" | `btcpay-helpers.sh tor` |

## Uninstall
```bash
cd /root/btcpayserver-docker && . btcpay-down.sh
rm -rf /root/btcpayserver-docker
rm -f /root/.env /etc/profile.d/btcpay-env.sh
docker volume ls | grep generated | awk '{print $2}' | xargs -r docker volume rm
```

## Environment Variables

| Variable | Default | Description |
|---|---|---|
| `BTCPAY_HOST` | empty (TOR only) | Domain for clearnet access |
| `NBITCOIN_NETWORK` | `mainnet` | Bitcoin network |
| `LIGHTNING` | `none` | Lightning implementation |
| `PRUNE` | `100` | Pruning size in GB |
