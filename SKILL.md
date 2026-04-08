---
name: btcpay-server-install
description: Deploy BTCPay Server via Docker — simple, conversational, one step at a time. No technical knowledge needed.
trigger: Install BTCPay Server
---

# BTCPay Server Installer

**I'll set up your Bitcoin payment server. You just answer questions. I'll handle the rest.**

No prior knowledge needed. No technical jargon. Just follow along.

---

## What I'm Building For You

A self-hosted Bitcoin payment server that:
- Runs on your own server — no monthly fees, no middleman
- Has its own Bitcoin node — validates transactions independently
- Is accessible via TOR — private, no DNS needed
- Auto-configures HTTPS — safe and secure

**Deploy time:** ~10 minutes
**Bitcoin sync:** 1–3 days after that (runs in background)

---

## Step 1 — Do you have a domain name?

A domain looks like: `btcpay.yoursite.com`

**If yes:** Point it to your server's IP address. I'll tell you what that is in a moment.
Then come back and say "yes, I have a domain."

**If no:** Just say "no domain" — TOR works great and is ready immediately.

---

## Step 2 — What will you use it for?

| Choice | Meaning |
|---|---|
| **Receive real payments** ⭐ | Live Bitcoin — production use |
| **Test things out first** | Testnet — fake Bitcoin, no value |

Choose the first one unless you're just learning.

---

## Step 3 — How much disk space can Bitcoin use?

Your Bitcoin node needs to store blockchain history. Here's the simple version:

| Choice | What it means |
|---|---|
| **100GB** ⭐ | ~1 year of history. Most users. |
| **50GB** | ~6 months of history. |
| **25GB** | ~3 months of history. Minimum for Lightning nodes. |
| **5GB** | ~2 weeks of history. Testing only. |

First option is right for 99% of people. If you want Lightning, you need at least 25GB.

---

## Step 4 — Lightning Network?

This is for fast, cheap payments — like tips or small invoices.

| Choice | Meaning |
|---|---|
| **Yes, add it** ⭐ | Most people want this |
| **No, just Bitcoin on-chain** | Simpler, slower payments |

Not sure? Add it. You can change your mind later.

---

## Step 5 — Ready to go?

Before we start, make sure your server is ready:

```
✅ I have SSH access to my server (VPS or dedicated)
✅ My server is Ubuntu or Debian Linux
✅ I have at least 100GB free disk space
✅ Ports 80 and 443 are open on my server
```

If you see any ❌ — tell me and we'll fix it first.

If everything is ✅ — say "deploy" and I'll start building your server.

---

## What Happens During Deployment

I run everything. You watch. Here's what I'll do:

1. Update your server and install Docker (if needed)
2. Set up BTCPay Server with your choices
3. Start everything running
4. Check that it all works

This takes about 10 minutes. I'll tell you when it's done and give you your access links.

---

## After Deployment

Two ways to access your server — use whichever works:

**TOR link** *(works immediately)*
I'll give you this right after deployment. No DNS needed.

**Your domain** *(works once DNS updates)*
Usually 5 minutes to a few hours after deployment.

---

## Changing Settings Later

Most settings can be changed after deployment without starting over:

```bash
# Stop BTCPay
cd /root/btcpayserver-docker && . btcpay-down.sh

# Edit your settings
nano /root/.env

# Restart with new settings
cd /root/btcpayserver-docker && . btcpay-setup.sh -i
```

Your blockchain data is preserved — it survives restarts and settings changes.

---

## Common Questions

**"My domain shows 503 error"**
DNS hasn't propagated yet. Use the TOR link — it works immediately.
Check DNS status: `dig +short your-domain.com A`

**"Bitcoin sync is taking forever"**
Normal. It downloads and verifies every block since 2009. Let it run — it won't re-download on restart.

**"How do I check if it's running?"**
`bash /root/btcpay-helpers.sh status`

**"Where's my TOR link?"**
`bash /root/btcpay-helpers.sh tor`

**"How do I restart it?"**
`bash /root/btcpay-helpers.sh restart`

Just ask me and I'll run these for you or teach you how.

---

## Uninstalling

Want to start completely fresh? Run this:

```bash
cd /root/btcpayserver-docker && . btcpay-down.sh
rm -rf /root/btcpayserver-docker
rm -f /root/.env /etc/profile.d/btcpay-env.sh
docker volume ls | grep generated | awk '{print $2}' | xargs -r docker volume rm
```
