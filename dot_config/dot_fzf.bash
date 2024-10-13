# Setup fzf
# ---------
if [[ ! "$PATH" == */home/richardslater/.local/fzf/bin* ]]; then
  PATH="${PATH:+${PATH}:}$HOME/.local/fzf/bin"
fi

eval "$(fzf --bash)"