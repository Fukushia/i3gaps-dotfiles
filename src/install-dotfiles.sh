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
sudo ln -fsv "$SCRIPTPATH/dotfiles" "~/.dotfiles"

for i in "${home_files[@]}"; {
	sudo ln -fsv "$SCRIPTPATH/home-files/$i" "~/.$1"
}

## i3 configs
mkdir -p "~/.config"
sudo ln -fsv "$SCRIPTPATH/i3" "~/.config"

## polybar
sudo ln -fsv "$SCRIPTPATH/polybar" "~/.config"

## Compton
sudo ln -fsv "$SCRIPTPATH/compton/compton.conf" "~/.config"

## wallpapers
sudo ln -fsv "$SCRIPTPATH/wallpapers" "~/.config"

## lightdm
for i in "${lightdm[@]}"; {
	sudo ln -fsv "$SCRIPTPATH/lightdm/$i" "/etc/lightdm/$1"
}
