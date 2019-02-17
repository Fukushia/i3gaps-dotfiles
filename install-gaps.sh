#!/bin/bash

SCRIPT=$(readlink -f "$0")
SCRIPTPATH=$(dirname "$SCRIPT")

# Mantain the sudo allong the script
sudo -v
$SCRIPTPATH/src/sudo-manager.sh &

#############
# FUNCTIONS #
#############


sudo_exec_command() {
	for i in "$@"; {
		sudo "$i"
	}
}

exec_command() {
	for i in "$@"; {
		eval "$i"
	}
}

install_pac() {
	for i in "$@"; {
		sudo pacman --needed --noconfirm -S "$i"
	}
}

install_opt() {
	for i in "$@"; {
		sudo pacman --needed --noconfirm --asdeps -S "$i"
	}
}

install_aur() {
	for i in "$@"; {
		git clone "https://aur.archlinux.org/$i.git"
		cd "$i"
		makepkg -si --needed --noconfirm
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
"libreoffice"
"mpv"
"youtube-dl"
"zsh"
"zsh-theme-powerlevel9k"
"android-file-transfer"
"libmtp"
"cmus"
"xreader"
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
# pandoc
# TODO
)

sudo_commands_programs=(
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

sudo_commands_others=(
"systemctl enable bluetooth && systemctl start bluetooth"
"systemctl enable org.cups.cupsd.service && systemctl start org.cups.cupsd.service"
"systemctl enable ufw.service &&systemctl start ufw.service"
"mkinitcpio -p linux-lts && grub-mkconfig -o /boot/grub/grub.cfg"
)

aur=(
"polybar"
#"brave"
"nerd-fonts-complete" # Or exec only SourceCodePro-install.sh in .src/
"preload"
"shantz-xwinwrap-bzr"
)

sudo_commands_aur=(
"systemctl enable preload"
"systemctl start preload"
)

commands_aur=(
"fc-cache -vf"
)

# EXECS #

## EXEC AS ROOT
# Timeout in 100min for not require sudo passwd in aur install
# TODO: Implement regex to avoid multiple multilibs
sudo -E bash <<EOF
echo '[multilib]' >> /etc/pacman.conf
echo 'Include = /etc/pacman.d/mirrorlist' >> /etc/pacman.conf
pacman -Syu
EOF

install_pac ${basePrograms[*]}
install_pac ${amdVideo[*]} ## CHANGE IT IF HAVE ANOTHER GPU!!!
install_pac ${programs[*]}
install_opt ${deps_programs[*]}
sudo_exec_command "${sudo_commands_programs[@]}"

## (CHANGE IT) FULL OPTIONALS
install_pac ${others[*]}
sudo_exec_command "${sudo_commands_others[@]}"

# AUR programs
install_aur ${aur[*]}

## EXEC AS ROOT
sudo_exec_command "${sudo_commands_aur[@]}"
exec_command "${commands_aur[@]}"

### OTHERS

## my nvim
cd ~/.config
git clone https://github.com/Fukushia/neoVim-configs.git
mv neoVim-configs nvim
cd nvim

# Install dotfiles
sudo $SCRIPTPATH/install-dotfiles.sh
cd "$SCRIPTPATH"

rm "$SCRIPTPATH"/src/sudo_status.txt
