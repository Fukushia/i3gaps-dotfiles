#!/bin/bash

# Mantain the sudo allong the script
sudo -v
./src/sudo-manager.sh &

SCRIPT=$(readlink -f "$0")
SCRIPTPATH=$(dirname "$SCRIPT")

#############
# FUNCTIONS #
#############

exec_command() {
	for i in "$@"; {
		"$i"
	}
}
fun_exec_command=$(declare -f exec_command)

install_pac() {
	for i in "$@"; {
		pacman --noconfirm -S "$i"
	}
}
fun_install_pac=$(declare -f install_pac)

install_opt() {
	for i in "$@"; {
		pacman --noconfirm --asdeps -S "$i"
	}
}
fun_install_opt=$(declare -f install_opt)

install_aur() {
	for i in "$@"; {
		git clone "https://aur.archlinux.org/$i.git"
		cd "$i"
		makepkg -si --noconfirm
		cd "$SCRIPTPATH"
	}
}

#######################
# INSTALLING PROGRAMS #
#######################

basePrograms=(
"xorg-server"
"xorg-xinit"
"xorg-apps"
"i3-gaps"
"alsa-utils"
"pulseaudio"
"pavucontrol"
# Plugins
"alsa-oss"
"alsa-lib"
# Codecs
"a52dec"
"faac"
"faad2"
"flac"
"jasper"
"lame"
"libdca"
"libdv"
"libmad"
"libmpeg2"
"libtheora"
"libvorbis"
"libxv"
"wavpack"
"x264"
"xvidcore"
)

amdVideo=(
"xf86-video-ati"
"lib32-mesa-dri"
"lib32-mesa-libgl"
)

programs=(
"rofi" # Window switcher, run dialog, ssh-launcher and dmenu
"rxvt-unicode"
"lightdm"
"lightdm-gtk-greeter"
"lightdm-gtk-greeter-settings"
"feh"
"neovim"
"ranger"
"ncmpcpp"
"flameshot"
"screenfetch"
"pandoc"
"openssh"
"git"
"compton"

#"network-manager-applet"
)

deps_programs=(
# i3-gaps
"i3lock"
"perl-anyevent-i3"
"perl-json-xs"
# lightdm
"gtk-engine-murrine"
"noto-fonts"
"ttf-roboto"
# noto-fonts and ttf-roboto deps
"noto-fonts-cjk"
"noto-fonts-emoji"
"noto-fonts-extra"
# neovim
"python2-neovim"
"python-neovim"
"xclip"
"xsel"
)

commands_programs=(
"systemctl enable lightdm"
)

others=(
"xf86-input-synaptcs" # touchpad driver
"network-manager-applet" # graphy network manager
# Bluetooth
"bluez"
"blueman"
"bluez-utils"
# Printer
"ghostscript"
"cups"
"gsfonts"
"gutenprint"
"libcups"
"hplip"
"system-config-printer"
"gufw" # firewall
"linux-lts"
"linux-lts-headers" # optional
)

commands_others=(
"systemctl enable bluetooth && systemctl start bluetooth"
"systemctl enable org.cups.cupsd.service && systemctl start org.cups.cupsd.service"
"systemctl enable ufw.service &&systemctl start ufw.service"
"mkinitcpio -p linux-lts && grub-mkconfig -o /boot/grub/grub.cfg"
)

aur=(
"polybar"
"brave"
"nerd-fonts-complete" # Or exec only SourceCodePro-install.sh in .src/
"preload"
#"shantz-xwinwrap-bzr"
)

commands_aur=(
"systemctl enable preload"
"systemctl start preload"
"fc-cache -vf"
)

# EXECS #

## EXEC AS ROOT
# Timeout in 100min for not require sudo passwd in aur install
sudo -E bash << EOF
echo '[multilib]' >> /etc/pacman.conf
echo 'Include = /etc/pacman.d/mirrorlist' >> /etc/pacman.conf
pacman -Syu
EOF

sudo bash -c "$fun_install_pac; install_pac '${basePrograms[@]}'"
sudo bash -c "$fun_install_pac; install_pac '${amdVideo[@]}'" ## CHANGE IT IF HAVE ANOTHER GPU!!!
sudo bash -c "$fun_install_pac; install_pac '${programs[@]}'"
sudo bash -c "$fun_install_opt; install_opt '${deps_programs[@]}'"
sudo bash -c "$fun_exec_command; exec_command '${commands_programs[@]}'"

#sudo bash -c "$fun_install_pac; install_pac "${others[@]}"
#sudo bash -c "$fun_exec_command; exec_command "${commands_others[@]}"

install_aur "${aur[@]}"

## EXEC AS ROOT
sudo bash -c "$fun_exec_command; exec_command '${commands_aur[@]}'"

### OTHERS

## my nvim
cd ~/.config
git clone https://github.com/Fukushia/neoVim-configs.git
mv neoVim-configs nvim
cd nvim

sudo -E << EOF
./install.sh
cd "$SCRIPTPATH"
EOF

rm "$SCRIPTPATH"/src/sudo_status.txt
