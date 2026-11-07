#!/bin/bash
# shellcheck disable=SC1091
set -e # Exit immediately if a command exits with a non-zero status

# Keep Ansible's Python modules and executables in one isolated environment.
# Mixing distro and pip installations can leave Ansible's modules at different
# versions (for example, distribution.py importing a helper absent from sys_info.py).
install_ansible() {
  local ansible_venv="${HOME}/.cache/chezmoi/ansible-venv"
  local ansible_python="${ansible_venv}/bin/python"

  if ! command -v python3 >/dev/null 2>&1; then
    echo "Error: python3 is required to install Ansible."
    exit 1
  fi

  mkdir -p "$(dirname "$ansible_venv")"
  if [[ ! -x "${ansible_venv}/bin/ansible-playbook" ]]; then
    echo "Creating isolated Ansible environment..."
    python3 -m venv "$ansible_venv"
  fi

  if ! "$ansible_python" -c 'from ansible.module_utils.common.sys_info import get_distribution_cpe_name' >/dev/null 2>&1; then
    echo "Installing or repairing Ansible in the isolated environment..."
    "$ansible_python" -m pip install --upgrade --force-reinstall ansible
  fi

  export PATH="${ansible_venv}/bin:${PATH}"
}

# Function to install with ansible-galaxy
install_roles() {
  REQUIREMENTS="${HOME}/.local/share/chezmoi/scripts/ansible/requirements.yml"
  if [ ! -f "$REQUIREMENTS" ]; then
    echo "Error: Playbook '$REQUIREMENTS' not found!"
    exit 1
  fi

  echo "Installing requirements"
  ansible-galaxy install -r "$REQUIREMENTS"
}

# Function to run the playbook
run_playbook() {
  PLAYBOOK="${HOME}/.local/share/chezmoi/scripts/ansible/playbook.yml"
  if [ ! -f "$PLAYBOOK" ]; then
    echo "Error: Playbook '$PLAYBOOK' not found!"
    exit 1
  fi

  echo "Running Ansible playbook: $PLAYBOOK"
  ansible-playbook "$PLAYBOOK" -i ./inventory/hosts.yml --ask-become-pass
}

# Main Execution
install_ansible
install_roles
run_playbook
