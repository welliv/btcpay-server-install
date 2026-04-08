#!/bin/bash
# Install BTCPay Server Installer as a Hermes skill
# Usage: curl -sSL https://raw.githubusercontent.com/welliv/btcpay-server-install/main/install-hermes.sh | bash

set -e

SKILL_DIR="$HOME/.hermes/skills/btcpay-server-install"
REPO_URL="${REPO_URL:-https://github.com/welliv/btcpay-server-install}"
BRANCH="${BRANCH:-main}"

echo "Installing BTCPay Server Installer skill..."
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
echo "Installed! To use:"
echo "  1. Start Hermes: hermes"
echo "  2. Say: Install BTCPay Server"
