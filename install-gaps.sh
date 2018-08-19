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

install_pac() {
	for i in "$@"; {
		pacman --noconfirm -S "$i"
	}
}

install_opt() {
	for i in "$@"; {
		pacman --noconfirm --asdeps -S "$i"
	}
}

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
"nerd-fonts-complete"
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
sudo -E bash << EOF
echo '[multilib]' >> /etc/pacman.conf
echo 'Include = /etc/pacman.d/mirrorlist' >> /etc/pacman.conf
pacman -Syu

install_pac "${basePrograms[@]}"
install_pac "${amdVideo[@]}" ## CHANGE IT IF HAVE ANOTHER GPU!!!
install_pac "${programs[@]}"
install_opt "${deps_programs[@]}" 
#install_pac "${others[@]}"
#exec_command "${commands_others[@]}"
EOF

install_aur "${aur[@]}"

## EXEC AS ROOT
sudo -E bash << EOF
exec_command "${commands_aur[@]}"
EOF

#######################
# FILES CONFIGURATION #
#######################

dotfiles=(
"alias"
"functions"
"inputrc"
"bashrc"
)

home_files=(
"Xresources"
"bash_profile"
)

i3_files=(
"config"
"feh-slides"
"flameshot.sh"
)

lightdm=(
"lightdm.conf"
"lightdm-gtk-greeter.conf"
)

# EXECS #

## EXEC AS ROOT
sudo -E bash << EOF
## dotfiles
mkdir -p ~/.dotfiles
for i in"${dotfiles[@]}"; {
  ln -fsv "$SCRIPTPATH/dotfiles/$1" "~/.dotfiles/$1"
}
for i in "${home_files[@]}"; {
	ln -fsv "$SCRIPTPATH/dotfiles/$i" "~/.$1"
}

## i3 configs
mkdir -p ~/.config
mkdir -p ~/.config/i3
for i in "${i3_files[@]}"; {
	ln -fsv "$SCRIPTPATH/i3/$i" "~/.config/i3/$1"
}

## lightdm
for i in "${lightdm[@]}"; {
	ln -fsv "$SCRIPTPATH/lightdm/$i" "/etc/lightdm/$1"
}
EOF

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
