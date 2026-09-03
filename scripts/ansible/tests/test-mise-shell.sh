#!/usr/bin/env bash
set -euo pipefail

repo_root="$(cd "$(dirname "${BASH_SOURCE[0]}")/../../.." && pwd)"
test_home="$(mktemp -d)"
trap 'rm -rf "$test_home"' EXIT

mkdir -p "$test_home/.config" "$test_home/.local/bin"
cp "$repo_root/dot_config/shell_common" "$test_home/.config/shell_common"
cp "$repo_root/dot_bashrc" "$test_home/.bashrc"
cp "$repo_root/dot_zshrc" "$test_home/.zshrc"

cat > "$test_home/.local/bin/mise" <<'EOF'
#!/bin/sh
if [ "$1" = "activate" ]; then
  printf 'export PATH="$HOME/.local/share/mise/shims:$PATH"\n'
fi
EOF
chmod 0755 "$test_home/.local/bin/mise"

assert_shell() {
  # shellcheck disable=SC2016
  HOME="$test_home" "$@" 'command -v mise >/dev/null && case ":$PATH:" in *":$HOME/.local/share/mise/shims:"*) exit 0;; *) exit 1;; esac'
}

assert_shell bash --noprofile --rcfile "$test_home/.bashrc" -ic

if command -v zsh >/dev/null; then
  HOME="$test_home" ZDOTDIR="$test_home" zsh -d -ic \
    'command -v mise >/dev/null && case ":$PATH:" in *":$HOME/.local/share/mise/shims:"*) exit 0;; *) exit 1;; esac'
fi

echo "mise shell activation verified"
