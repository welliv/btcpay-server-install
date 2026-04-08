#!/bin/bash
# Install BTCPay Server Installer as a Hermes Agent skill
#
# Usage:
#   curl -sSL https://raw.githubusercontent.com/welliv/btcpay-server-install/main/install-hermes.sh | bash
#
# After install, say to Hermes:
#   "Install BTCPay Server"

set -e

SKILL_DIR="$HOME/.hermes/skills/btcpay-server-install"
REPO_URL="${REPO_URL:-https://github.com/welliv/btcpay-server-install}"
BRANCH="${BRANCH:-main}"

echo "Installing BTCPay Server Installer skill for Hermes Agent..."
echo "Repo: $REPO_URL"

# Clone or update
if [ -d "$SKILL_DIR" ]; then
  echo "Updating existing installation..."
  git -C "$SKILL_DIR" pull
else
  echo "Cloning to $SKILL_DIR..."
  mkdir -p "$HOME/.hermes/skills"
  git clone -b "$BRANCH" "$REPO_URL" "$SKILL_DIR"
fi

echo ""
echo "Installed successfully!"
echo ""
echo "To use:"
echo "  1. Start Hermes: hermes"
echo "  2. Say: Install BTCPay Server"
echo ""
echo "The skill will guide your user through setup — one question at a time."
