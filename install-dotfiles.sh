#!/bin/bash
SCRIPT=$(readlink -f "$0")
SCRIPTPATH=$(dirname "$SCRIPT")

home_files=(
  "bash_profile"
  "inputrc"
  "Xresources"
  "fzf.bash"
  "fzf.zsh"
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
ln -fsv "$SCRIPTPATH/wallpapers" "$HOME/"

## lightdm
sudo cp "$SCRIPTPATH/wallpapers/images/amazing-blur-breathtaking.jpg" "/usr/share/pixmaps/gtkWallpaper.jpg"
for i in "${lightdm[@]}"; {
	sudo rm -f "/etc/lightdm/$i"
	sudo cp -f "$SCRIPTPATH/lightdm/$i" "/etc/lightdm/"
}
