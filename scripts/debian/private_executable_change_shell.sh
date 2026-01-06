#!/usr/bin/env bash
# shellcheck disable=SC1009,SC1054,SC1056,SC1072,SC1073,SC1083
{{- if eq .chezmoi.os "linux" }}

echo 'Changing shell to zsh, enter password or Ctrl+C'
chsh -s "$(which zsh)"

{{- end }}
