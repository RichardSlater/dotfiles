#!/bin/bash

TASKCTL_VERSION="1.7.5"

wget "https://github.com/Ensono/taskctl/releases/download/${TASKCTL_VERSION}/taskctl-linux-amd64" -O ~/.local/bin/taskctl
chmod 500 ~/.local/bin/taskctl
chown "$USER":"$GROUP" ~/.local/bin/taskctl
