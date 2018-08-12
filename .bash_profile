#
# ~/.bash_profile
#

for DOTFILE in `find ~/Projects/.*`; do
  [ -f "$DOTFILE" ] && source "$DOTFILE"
done

[[ -f ~/.bashrc ]] && . ~/.bashrc
