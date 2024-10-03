BACKUP_FILE="/tmp/${USERNAME}_wsl_backup.tar.gz"

tar -cvzf "${BACKUP_FILE}" \
  --exclude-backups --exclude-caches-all --exclude-vcs \
  --exclude="$HOME/.npm" --exclude="$HOME/.nvm" \
  --exclude="$HOME/.local" --exclude="$HOME/.foundry" \
  --exclude="$HOME/.cache" --exclude="$HOME/.vscode-server" \
  --exclude="$HOME/.rustup" --exclude="$HOME/.cargo" \
  --exclude="$HOME/.docker" --exclude="$HOME/snap" \
  --exclude="$HOME/go" --exclude="*/.pnpm/*" \
  --exclude="*/.next/*" "$HOME"

echo "DONE!! $BACKUP_FILE"
echo "{\\}wsl.localhost{\}${WSL_DISTRO_NAME}{\}tmp"
