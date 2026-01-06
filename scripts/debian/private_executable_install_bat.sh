#!/bin/bash

BAT_VER="0.24.0"
TEMP_DIR="/tmp/bat_$(
  tr -dc a-z0-9 </dev/urandom | head -c 6
  echo
)"

echo "Creating directory ${TEMP_DIR}"
mkdir -p "$TEMP_DIR"
cd "$TEMP_DIR" || exit
wget "https://github.com/sharkdp/bat/releases/download/v${BAT_VER}/bat_${BAT_VER}_amd64.deb" -P "$TEMP_DIR"
sudo dpkg -i "${TEMP_DIR}/bat_${BAT_VER}_amd64.deb"
rm -rf "$TEMP_DIR"
