#!/bin/bash
# BTCPay Server — Management Helper
# Usage: bash btcpay-helpers.sh {command}
#
# Commands:
#   status   — Check if everything is running
#   logs     — View BTCPay server logs
#   tor      — Get your TOR link
#   restart  — Restart everything
#   stop     — Stop BTCPay
#   start    — Start BTCPay
#   btc      — Bitcoin node info (sync status, block height)
#   help     — Show this help

BTCPAY_DIR="${BTCPAY_DIR:-/root/btcpayserver-docker}"

RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
CYAN='\033[0;36m'
NC='\033[0m'

# Detect container names dynamically
get_container() {
  local name_pattern="$1"
  docker ps --format '{{.Names}}' 2>/dev/null | grep "$name_pattern" | head -1
}

BTC_CONTAINER=$(get_container "bitcoind")
BTCPAY_CONTAINER=$(get_container "btcpayserver")
TOR_CONTAINER=$(get_container "^tor$")

status() {
  echo ""
  echo -e "${CYAN}=== BTCPay Containers ===${NC}"
  docker ps --format "table {{.Names}}\t{{.Status}}" 2>/dev/null | grep -E "btcpay|bitcoin|postgres|nbxplorer|nginx|tor|letsencrypt" || echo "No BTCPay containers running."
  echo ""
}

logs() {
  echo ""
  echo -e "${CYAN}=== BTCPay Logs (last 30 lines) ===${NC}"
  if [ -n "$BTCPAY_CONTAINER" ]; then
    docker logs --tail 30 "$BTCPAY_CONTAINER" 2>&1
  else
    echo "BTCPay container not found."
  fi
  echo ""
}

tor() {
  echo ""
  if [ -n "$TOR_CONTAINER" ]; then
    TOR_ADDRESS=$(docker exec "$TOR_CONTAINER" cat /var/lib/tor/hidden_services/BTCPayServer/hostname 2>/dev/null || echo "")
    if [ -n "$TOR_ADDRESS" ]; then
      echo -e "${GREEN}🧅 Your TOR link:${NC}"
      echo "   http://$TOR_ADDRESS"
    else
      echo -e "${YELLOW}🧅 TOR address not generated yet.${NC}"
      echo "   This may take a few minutes after first startup."
    fi
  else
    echo -e "${RED}🧅 TOR container not found.${NC}"
  fi
  echo ""
}

restart() {
  echo ""
  echo "Restarting BTCPay..."
  # shellcheck source=/dev/null
  cd "$BTCPAY_DIR" && . ./btcpay-down.sh 2>/dev/null
  sleep 2
  # shellcheck source=/dev/null
  cd "$BTCPAY_DIR" && . ./btcpay-setup.sh -i 2>/dev/null
  echo -e "${GREEN}Done.${NC}"
  sleep 3
  status
}

stop() {
  echo ""
  echo "Stopping BTCPay..."
  # shellcheck source=/dev/null
  cd "$BTCPAY_DIR" && . ./btcpay-down.sh 2>/dev/null
  echo -e "${GREEN}Stopped.${NC}"
}

start() {
  echo ""
  echo "Starting BTCPay..."
  # shellcheck source=/dev/null
  cd "$BTCPAY_DIR" && . ./btcpay-setup.sh -i 2>/dev/null
  echo -e "${GREEN}Done.${NC}"
  sleep 3
  status
}

btc() {
  echo ""
  echo -e "${CYAN}=== Bitcoin Node Status ===${NC}"

  if [ -z "$BTC_CONTAINER" ]; then
    echo -e "${RED}Bitcoin container not found.${NC}"
    echo ""
    return
  fi

  # Get blockchain info — try with timeout
  INFO=$(docker exec "$BTC_CONTAINER" bitcoin-cli getblockchaininfo 2>&1) || {
    echo -e "${YELLOW}Bitcoin is still starting up...${NC}"
    echo "RPC will be available in a few minutes."
    echo ""
    return
  }

  HEIGHT=$(echo "$INFO" | grep -E '"blocks"' | awk '{print $2}' | tr -d ',')
  PROGRESS=$(echo "$INFO" | grep -E '"verificationprogress"' | awk '{print $2}' | tr -d ',' | cut -c1-6)
  PEERS=$(echo "$INFO" | grep -E '"connections"' | awk '{print $2}' | tr -d ',')
  PRUNED=$(echo "$INFO" | grep -E '"pruned"' | awk '{print $2}' | tr -d ',')

  echo "  Block height:   $HEIGHT"
  echo "  Sync progress:  ${PROGRESS}% synced"
  echo "  Peers:          $PEERS"
  echo "  Pruned node:    $PRUNED"
  echo ""
}

logs_btc() {
  echo ""
  echo -e "${CYAN}=== Bitcoin Node Logs (last 20 lines) ===${NC}"
  if [ -n "$BTC_CONTAINER" ]; then
    docker logs --tail 20 "$BTC_CONTAINER" 2>&1
  else
    echo "Bitcoin container not found."
  fi
  echo ""
}

help() {
  echo ""
  echo -e "${CYAN}BTCPay Helper Commands:${NC}"
  echo ""
  echo "  bash btcpay-helpers.sh status    — Check if everything is running"
  echo "  bash btcpay-helpers.sh logs     — View BTCPay server logs"
  echo "  bash btcpay-helpers.sh tor       — Get your TOR link"
  echo "  bash btcpay-helpers.sh btc      — Bitcoin node sync status"
  echo "  bash btcpay-helpers.sh restart  — Restart everything"
  echo "  bash btcpay-helpers.sh stop     — Stop BTCPay"
  echo "  bash btcpay-helpers.sh start    — Start BTCPay"
  echo "  bash btcpay-helpers.sh help     — Show this help"
  echo ""
}

case "$1" in
  status) status ;;
  logs) logs ;;
  tor) tor ;;
  restart) restart ;;
  stop) stop ;;
  start) start ;;
  btc) btc ;;
  bitcoind-logs|btc-logs) logs_btc ;;
  help|--help|-h) help ;;
  *) help ;;
esac
