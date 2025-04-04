#!/bin/bash

GO_VER="go1.24.2.linux-amd64.tar.gz"
TEMP_DIR="/tmp/go_$(
  tr -dc a-z0-9 </dev/urandom | head -c 6
  echo
)"

echo "Creating directory ${TEMP_DIR}"
mkdir -p "$TEMP_DIR"
cd "$TEMP_DIR"
wget "https://go.dev/dl/${GO_VER}" -P "$TEMP_DIR"
sudo rm -rf /usr/local/go && sudo tar -C /usr/local -xzf "${TEMP_DIR}/${GO_VER}"
rm -rf "$TEMP_DIR"
