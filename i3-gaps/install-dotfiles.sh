#!/bin/bash
SCRIPT=$(readlink -f "$0")
SCRIPTPATH=$(dirname "$SCRIPT")

home_files() {
  "bash_profile"
  "Xresources"
}

lightdm() {
  "lightdm.conf"
  "lightdm-gtk-greeter.conf"
}
## EXEC AS ROOT

## dotfiles
ln -fsv $SCRIPTPATH/dotfiles ~/.dotfiles

for i in "${home_files[@]}"; {
	ln -fsv "$SCRIPTPATH/home-files$i" "~/.$1"
}

## i3 configs
mkdir -p ~/.config
ln -fsv "$SCRIPTPATH/i3" "~/.config/"

## lightdm
sudo -E bash << EOF
for i in "${lightdm[@]}"; {
	ln -fsv "$SCRIPTPATH/lightdm/$i" "/etc/lightdm/$1"
}
EOF
