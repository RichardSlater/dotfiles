#!/bin/bash
# Helper script for testing dotfiles in Docker
# This script runs inside the container

set -e

echo "=== Installing dependencies ==="
apt-get update -qq
apt-get install -y -qq curl git ca-certificates > /dev/null

echo "=== Installing chezmoi ==="
cd /tmp
curl -fsSL https://get.chezmoi.io -o install-chezmoi.sh
chmod +x install-chezmoi.sh
./install-chezmoi.sh -b /usr/local/bin

echo "=== Chezmoi Diff (what would be applied) ==="
chezmoi diff --source=/dotfiles || true

echo ""
echo "=== Chezmoi Doctor ==="
chezmoi doctor --source=/dotfiles || true

echo ""
echo "=== Chezmoi Managed Files ==="
chezmoi managed --source=/dotfiles || true
