#!/bin/bash

set -e  # Exit immediately if a command exits with a non-zero status

# Function to check and install Ansible
install_ansible() {
    if command -v ansible >/dev/null 2>&1; then
        echo "Ansible is already installed."
        return
    fi

    echo "Installing Ansible..."
    if [[ -f /etc/os-release ]]; then
        . /etc/os-release
        case "$ID" in
            ubuntu|debian)
                sudo apt update
                sudo apt install -y ansible
                ;;
            fedora)
                sudo dnf install -y ansible
                ;;
            centos|rhel)
                sudo yum install -y epel-release
                sudo yum install -y ansible
                ;;
            arch)
                sudo pacman -Syu --noconfirm ansible
                ;;
            *)
                echo "Unsupported Linux distribution: $ID"
                exit 1
                ;;
        esac
    else
        echo "Could not detect the Linux distribution."
        exit 1
    fi
}

# Function to run the playbook
run_playbook() {
    PLAYBOOK="${HOME}/.local/share/chezmoi/scripts/ansible/playbook.yml"
    if [ ! -f "$PLAYBOOK" ]; then
        echo "Error: Playbook '$PLAYBOOK' not found!"
        exit 1
    fi

    echo "Running Ansible playbook: $PLAYBOOK"
    ansible-playbook "$PLAYBOOK" --ask-become-pass
}

# Main Execution
install_ansible
run_playbook
