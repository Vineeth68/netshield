#!/usr/bin/env bash
#
# NetShield installer
# Sets up Pi-hole + Tailscale on a Raspberry Pi (Raspberry Pi OS / Debian-based).
#
# Usage:
#   chmod +x install.sh
#   ./install.sh
#
set -euo pipefail

echo "=============================================="
echo "  NetShield Installer — Pi-hole + Tailscale"
echo "=============================================="

# 1. System update
echo "[1/4] Updating system packages..."
sudo apt-get update -y
sudo apt-get upgrade -y

# 2. Install Pi-hole
echo "[2/4] Installing Pi-hole..."
curl -sSL https://install.pi-hole.net | bash

# 3. Install Tailscale
echo "[3/4] Installing Tailscale..."
curl -fsSL https://tailscale.com/install.sh | sh

echo "Starting Tailscale — a browser login link will be printed below."
sudo tailscale up

# 4. Load custom blocklists
echo "[4/4] Loading custom blocklists..."
if [ -f "$(dirname "$0")/../config/pihole/custom-blocklists.txt" ]; then
  while IFS= read -r url; do
    [ -z "$url" ] && continue
    [[ "$url" == \#* ]] && continue
    pihole -a adlist add "$url" || true
  done < "$(dirname "$0")/../config/pihole/custom-blocklists.txt"
  pihole -g
else
  echo "No custom-blocklists.txt found — skipping."
fi

echo "=============================================="
echo " Done. Next steps:"
echo "  1. Open the Pi-hole dashboard: http://<pi-ip>/admin"
echo "  2. In the Tailscale admin console, set this Pi as the"
echo "     nameserver for your tailnet: https://login.tailscale.com/admin/dns"
echo "  3. On each client device, run 'tailscale up --accept-dns' (or enable"
echo "     'Accept DNS' in the Tailscale app) to route DNS through the Pi."
echo "=============================================="
