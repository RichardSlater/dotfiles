# Setup fzf
# ---------
if [[ ! "$PATH" == */home/richardslater/.local/fzf/bin* ]]; then
  PATH="${PATH:+${PATH}:}/home/richardslater/.local/fzf/bin"
fi

source <(fzf --zsh)
