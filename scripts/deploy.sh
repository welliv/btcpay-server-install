#!/bin/bash
# =============================================
# BTCPay Server — Deployment Script
# =============================================

set -e

# === SETTINGS — override with env vars or edit directly ===
BTCPAY_HOST="${BTCPAY_HOST:-}"           # Your domain, or leave empty for TOR only
NBITCOIN_NETWORK="${NBITCOIN_NETWORK:-mainnet}"
LIGHTNING="${LIGHTNING:-none}"          # lnd | clightning | eclair | none
PRUNE="${PRUNE:-100}"                   # 5 | 25 | 50 | 100 (GB)
# =============================================

RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m'

log() { echo -e "${GREEN}[INFO]${NC} $1"; }
warn() { echo -e "${YELLOW}[WARN]${NC} $1"; }
err() { echo -e "${RED}[ERROR]${NC} $1"; exit 1; }

echo ""
echo "========================================"
echo "  BTCPay Server Deployment"
echo "========================================"
echo ""

# === Auto-detect public IP ===
PUBLIC_IP=$(curl -s ifconfig.me 2>/dev/null || curl -s ipinfo.io/ip 2>/dev/null || echo "")
if [ -n "$PUBLIC_IP" ]; then
  log "Detected public IP: $PUBLIC_IP"
  if [ -z "$BTCPAY_HOST" ]; then
    warn "No domain set — using TOR only."
    warn "To use a domain, point it to: $PUBLIC_IP"
  fi
else
  warn "Could not detect public IP automatically."
  warn "If using a domain, make sure DNS points to your server."
fi
echo ""

# === Check OS ===
if [ ! -f /etc/os-release ]; then
  err "Cannot detect OS. This script requires Ubuntu or Debian."
fi
# shellcheck source=/etc/os-release disable=SC1091
. /etc/os-release
if [ "$ID" != "ubuntu" ] && [ "$ID" != "debian" ]; then
  warn "This script is tested on Ubuntu/Debian. Detected: $NAME"
  warn "Continuing anyway — may still work."
fi

# === Check if Docker is installed ===
if command -v docker &>/dev/null && docker info &>/dev/null; then
  log "Docker is already installed — skipping."
else
  log "Installing Docker..."
  curl -fsSL https://get.docker.com | sh > /dev/null 2>&1
  systemctl enable docker > /dev/null 2>&1
  systemctl start docker
  log "Docker installed."
fi
echo ""

# === Clone or update repo ===
if [ -d "/root/btcpayserver-docker" ]; then
  log "Updating existing BTCPay repository..."
  cd /root/btcpayserver-docker && git pull
else
  log "Cloning BTCPay repository..."
  git clone https://github.com/btcpayserver/btcpayserver-docker /root/btcpayserver-docker
fi
cd /root/btcpayserver-docker
echo ""

# === Configure environment ===
log "Configuring settings..."

export BTCPAY_IMAGE=""
export LIGHTNING_ALIAS=""
export BTCPAYGEN_CRYPTO1="btc"
export BTCPAYGEN_REVERSEPROXY="nginx"
export BTCPAY_ENABLE_SSH=false
export NBITCOIN_NETWORK

# Pruning: 100GB=~1yr, 50GB=~6mo, 25GB=~3mo (min Lightning), 5GB=~2wk
case "$PRUNE" in
  100) PRUNE_ARG="opt-add-prune-100" ;;
  50)  PRUNE_ARG="opt-add-prune-50" ;;
  25)  PRUNE_ARG="opt-add-prune-25" ;;
  5)   PRUNE_ARG="opt-add-prune-5" ;;
  0|"") PRUNE_ARG="" ;;
  *)   PRUNE_ARG="opt-add-prune-100" ;;
esac
export BTCPAYGEN_ADDITIONAL_FRAGMENTS="$PRUNE_ARG"

# Lightning
case "$LIGHTNING" in
  lnd)        export BTCPAYGEN_LIGHTNING="lnd" ;;
  clightning) export BTCPAYGEN_LIGHTNING="clightning" ;;
  eclair)     export BTCPAYGEN_LIGHTNING="eclair" ;;
  none|"")    export BTCPAYGEN_LIGHTNING="none" ;;
  *)          export BTCPAYGEN_LIGHTNING="none" ;;
esac

# Domain / TOR
if [ -n "$BTCPAY_HOST" ]; then
  export BTCPAY_HOST
  export BTCPAY_PROTOCOL="https"
  export LETSENCRYPT_EMAIL="admin@${BTCPAY_HOST}"
  export NGINX_AUTOINSTALL=true
  log "Using domain: $BTCPAY_HOST"
else
  export BTCPAY_PROTOCOL="http"
  export BTCPAY_HOST="localhost"
  export BTCPAY_LOCAL_TOR=true
  warn "No domain — using TOR only."
fi

# Save .env for future edits
env | grep -E "^BTCPAY|^NBITCOIN|^PRUNE|^LIGHTNING|^BTCPAYGEN|^LETSENCRYPT|^NGINX" > /root/.env
echo ""

# === Deploy ===
log "Starting BTCPay Server..."
log "This takes 5-10 minutes. Do not interrupt."
echo ""
# shellcheck source=/dev/null
. ./btcpay-setup.sh -i
echo ""

# === Verify ===
log "Verifying deployment..."
sleep 5

CONTAINERS=$(docker ps --format "{{.Names}}" 2>/dev/null | grep -cE "btcpay|bitcoin|postgres|nbxplorer|nginx|tor|letsencrypt")
if [ "$CONTAINERS" -ge 7 ]; then
  log "All containers are running. Deployment successful!"
else
  warn "Only $CONTAINERS containers running. Some may still be starting."
fi
echo ""

# === Show access links ===
echo "========================================"
echo "  Your BTCPay Server is Ready!"
echo "========================================"
echo ""

TOR_ADDRESS=$(docker exec tor cat /var/lib/tor/hidden_services/BTCPayServer/hostname 2>/dev/null || echo "")
if [ -n "$TOR_ADDRESS" ]; then
  echo -e "${GREEN}🧅 TOR link (works now):${NC}"
  echo "   http://$TOR_ADDRESS"
  echo ""
fi

if [ -n "$BTCPAY_HOST" ] && [ "$BTCPAY_HOST" != "localhost" ]; then
  echo -e "${GREEN}🌐 Your domain (works once DNS updates):${NC}"
  echo "   https://$BTCPAY_HOST"
  echo ""
fi

echo "========================================"
echo ""
log "Bitcoin is syncing in the background."
log "This takes 1-3 days. Your server is ready to use now."
log "Visit your TOR link above and register your account."
echo ""
