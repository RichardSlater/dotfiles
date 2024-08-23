#!/bin/bash

echo "Installing dependencies"
sudo apt install -y libevent-dev ncurses-dev build-essential bison pkg-config autotools-dev automake

TEMP_DIR="/tmp/tmux_$(tr -dc a-z0-9 </dev/urandom | head -c 6; echo)"

echo "Creating directory ${TEMP_DIR}"
mkdir -p "$TEMP_DIR"
cd "$TEMP_DIR"
git clone https://github.com/tmux/tmux.git $TEMP_DIR
sh ./autogen.sh
./configure
make && sudo make install
cd -
rm -rf "$TEMP_DIR"
