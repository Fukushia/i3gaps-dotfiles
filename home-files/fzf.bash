# Setup fzf
# ---------
if [[ ! "$PATH" == */home/vinicius/.fzf/bin* ]]; then
  export PATH="$PATH:/home/vinicius/.fzf/bin"
fi

# Auto-completion
# ---------------
[[ $- == *i* ]] && source "/home/vinicius/.fzf/shell/completion.bash" 2> /dev/null

# Key bindings
# ------------
source "/home/vinicius/.fzf/shell/key-bindings.bash"

export PATH=$PATH:/opt/mssql-tools/bin

for DOTFILE in `find ~/.dotfiles/*`; do
  [ -f "$DOTFILE" ] && source "$DOTFILE"
done

clear
