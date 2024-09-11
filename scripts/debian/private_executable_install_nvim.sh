#!/bin/bash

echo "Installing dependencies"
sudo apt-get install ninja-build gettext cmake unzip curl build-essential -y

TEMP_DIR="/tmp/nvim_$(
  tr -dc a-z0-9 </dev/urandom | head -c 6
  echo
)"

echo "Creating directory ${TEMP_DIR}"
mkdir -p "$TEMP_DIR"
cd "$TEMP_DIR"
git clone https://github.com/neovim/neovim $TEMP_DIR
make CMAKE_BUILD_TYPE=RelWithDebInfo
sudo make install
sudo rm -rf "$TEMP_DIR"
