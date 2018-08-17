SCRIPT=$(readlink -f "$0")
SCRIPTPATH=$(dirname "$SCRIPT")

exec_command() {
	for i in "$@"; {
		"$i"
	}
}

install_pac() {
	for i in "$@"; {
		pacman -S "$i"
	}
}

install_opt() {
	for i in "$@"; {
		pacman --asdeps -S "$i"
	}
}

install_aur() {
	for i in "$@"; {
		git clone "https://aur.archlinux.org/$i.git"
		cd "$i"
		makepkg -si
		cd "$SCRIPTPATH"
	}
}

pre_commands=(
# Add [multilib] to pacman
"eval echo '[multilib]' > /etc/pacman.conf"
"eval echo 'Include = /etc/pacman.d/mirrorlist' > /etc/pacman.conf"
"pacman -Syu"
)

exec_command ${pre_commands[@]}

basePrograms=(
"xorg-server"
"xorg-xinit"
"xorg-apps"
"i3-wm"
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
"libmap"
"libmpeg2"
"libtheora"
"libvorbis"
"libxv"
"wavpack"
"x264"
"xvidcore"
)

install_pac ${basePrograms[@]}

amdVideo=(
"xf86-video-ati"
"lib32-mesa-dri"
"lib32-mesa-libgl"
)

## CHANGE IT IF HAVE ANOTHER GPU!!!
install_pac ${amdVideo[@]}

programs=(
"rofi" # Window switcher, run dialog, ssh-launcher and dmenu
"rxvt-unicode"
"lightdm"
"lightdm gtk-greeter"
"lightdm-gtk-greeter-settings"
"feh"
"neovim"
"compton"
"ranger"
"ncmpcpp"
"flameshot"
"network-manager-applet"
"screenfetch"
"pandoc"
"openssh"
"git"
)

install_pac ${programs[@]}

deps_programs=(
# i3-wm
"i3lock"
"perl"
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

install_opt ${deps_programs[@]}

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

#install_pac ${others[@]}

commands_others=(
"systemctl enable bluetooth && systemctl start bluetooth"
"systemctl enable org.cups.cupsd.service && systemctl start org.cups.cupsd.service"
"systemctl enable ufw.service &&systemctl start ufw.service"
"mkinitcpio -p linux-lts && grub-mkconfig -o /boot/grub/grub.cfg"
)

#exec_command ${commands_others[@]}

aur=(
"polybar"
"brave"
"nerd-fonts-complete"
"preload"
"shantz-xwinwrap-bzr"
)

install_aur ${aur[@]}

commands_aur=(
"systemctl enable preload && systemctl start preload"
"fc-cache -vf"
)

exec_command ${commands_aur[@]}

files=(
".alias"
".functions"
".inputrc"
".Xresources"
".bash_profile"
".bashrc"
)

for i in ${files[@]}; {
	ln -sv $SCRIPTPATH/$i ~
}

## i3-wm
i3_dirbase=$SCRIPTPATH/i3-wm

i3_files=(
"config"
"feh-slides"
"flameshot.sh"
)

for i in ${i3_files[@]}; {
	ln -sv "$i3_dirbase/$i" ~/.config/i3
}

## lightdm
lightdm_dirbase=$SCRIPTPATH/lightdm
lightdm=(
"lightdm.conf"
"lightdm-gtk-greeter.conf"
)

for i in ${lightdm[@]}; {
	ln -sv "$lightdm_dirbase/$i" /etc/lightdm/
}

## OTHERS

## my nvim
cd ~/.config
git clone https://github.com/Fukushia/neoVim-configs.git
cd neoVim-configs
./install.sh
cd $SCRIPTPATH 
