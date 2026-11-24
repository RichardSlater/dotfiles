#!/usr/bin/env bash

set -euo pipefail

if [ "${DOTFILES_DISPOSABLE_VM:-}" != 1 ]; then
  echo "Set DOTFILES_DISPOSABLE_VM=1 only in a disposable VM; this test modifies the system." >&2
  exit 1
fi

if [ "$(id -u)" -eq 0 ] || [ "$(ps -p 1 -o comm=)" != systemd ] || ! systemctl --user show-environment >/dev/null; then
  echo "Run this provisioning test as a non-root user with a systemd session in a disposable Debian VM." >&2
  exit 1
fi

SOURCE_DIR="$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")/.." && pwd)"
TEST_DIR="$(mktemp -d)"
trap 'rm -rf -- "$TEST_DIR"' EXIT
ANSIBLE_VENV="$TEST_DIR/venv"
# Bookworm's ansible-core 2.14 lacks deb822_repository (added in 2.15).
# The 2.19 series supports Bookworm's controller Python 3.11.
ANSIBLE_CORE_VERSION=2.19.15

echo "=== Installing dependencies ==="
sudo -n apt-get update -qq
sudo -n apt-get install -y -qq python3-venv python3-apt python3-debian git curl ca-certificates > /dev/null

# Isolate the controller from distro Python packages. The inventory deliberately
# keeps managed modules on /usr/bin/python3 for python3-apt and python3-debian.
python3 -m venv "$ANSIBLE_VENV"
"$ANSIBLE_VENV/bin/python" -m pip install "ansible-core==$ANSIBLE_CORE_VERSION"
export PATH="$ANSIBLE_VENV/bin:$PATH"
ansible --version

cd "$SOURCE_DIR/scripts/ansible"

echo "=== Installing Galaxy requirements ==="
ansible-galaxy install -r requirements.yml > /dev/null

echo "=== First playbook run ==="
ansible-playbook playbook.yml -i inventory/hosts.yml -c local

echo "=== Second playbook run ==="
ANSIBLE_NOCOLOR=1 ansible-playbook playbook.yml -i inventory/hosts.yml -c local | tee "$TEST_DIR/second-run.log"

recap_line="$(grep '^localhost' "$TEST_DIR/second-run.log" | tail -n 1 || true)"

if [ -z "$recap_line" ]; then
  echo "Missing play recap from second run" >&2
  exit 1
fi

changed_count="$(printf '%s\n' "$recap_line" | sed -n 's/.*changed=\([0-9][0-9]*\).*/\1/p')"
failed_count="$(printf '%s\n' "$recap_line" | sed -n 's/.*failed=\([0-9][0-9]*\).*/\1/p')"
unreachable_count="$(printf '%s\n' "$recap_line" | sed -n 's/.*unreachable=\([0-9][0-9]*\).*/\1/p')"

if [ -z "$changed_count" ] || [ -z "$failed_count" ] || [ -z "$unreachable_count" ]; then
  echo "Could not parse play recap: $recap_line" >&2
  exit 1
fi

if [ "$failed_count" -ne 0 ] || [ "$unreachable_count" -ne 0 ]; then
  echo "Second playbook run failed: $recap_line" >&2
  exit 1
fi

if [ "$changed_count" -ne 0 ]; then
  echo "Second playbook run was not idempotent: $recap_line" >&2
  exit 1
fi

echo "Second run was idempotent: $recap_line"
