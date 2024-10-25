#!/bin/bash

PWSH_VERSION="7.4.6"

echo "Installing dependencies"
sudo apt update
sudo apt install -y wget

TEMP_DIR="/tmp/pwsh_$(
  tr -dc a-z0-9 </dev/urandom | head -c 6
  echo
)"

echo "Creating directory ${TEMP_DIR}"
mkdir -p "$TEMP_DIR"
cd "$TEMP_DIR"

wget "https://github.com/PowerShell/PowerShell/releases/download/v${PWSH_VERSION}/powershell_${PWSH_VERSION}-1.deb_amd64.deb"
sudo dpkg -i "powershell_${PWSH_VERSION}-1.deb_amd64.deb"
sudo apt install -f

rm -rf "$TEMP_DIR"
