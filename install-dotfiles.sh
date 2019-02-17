#!/bin/bash
SCRIPT=$(readlink -f "$0")
SCRIPTPATH=$(dirname "$SCRIPT")

home_files=(
  "bash_profile"
  "Xresources"
)

lightdm=(
  "lightdm.conf"
  "lightdm-gtk-greeter.conf"
)

## dotfiles
ln -fsv "$SCRIPTPATH/dotfiles" "$HOME/" 
mv "$HOME/dotfiles" "$HOME/.dotfiles"

for i in "${home_files[@]}"; {
	ln -fsv "$SCRIPTPATH/home-files/$i" "$HOME/.$i"
}

## i3 configs
mkdir -p "$HOME/.config"
ln -fsv "$SCRIPTPATH/i3" "$HOME/.config/"

## polybar
ln -fsv "$SCRIPTPATH/polybar" "$HOME/.config/"

## Compton
ln -fsv "$SCRIPTPATH/compton/compton.conf" "$HOME/.config/compton.conf"

## wallpapers
ln -fsv "$SCRIPTPATH/wallpapers" "$HOME/.config/"

## lightdm
for i in "${lightdm[@]}"; {
	sudo ln -fsv "$SCRIPTPATH/lightdm/$i" "/etc/lightdm/"
}
