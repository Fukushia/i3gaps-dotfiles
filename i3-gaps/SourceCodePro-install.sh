# get_latest_release from https://gist.github.com/lukechilds/a83e1d7127b78fef38c2914c4ececc3c
get_latest_release() {
  curl --silent "https://api.github.com/repos/$1/releases/latest" | # Get latest release from GitHub api
    grep '"tag_name":' |                                            # Get tag line
    sed -E 's/.*"([^"]+)".*/\1/'                                    # Pluck JSON value
}

last=`get_latest_release "ryanoasis/nerd-fonts"`

wget https://github.com/ryanoasis/nerd-fonts/releases/download/$last/SourceCodePro.zip
sudo -E bash << EOF
install -dm 755 /usr/share/fonts/nerd-fonts-complete/ttf
unzip -a SourceCodePro.zip -d /usr/share/fonts/nerd-fonts-complete/ttf
EOF

fc-cache -s
mkfontscale /usr/share/fonts/TTF
mkfontdir /usr/share/fonts/TTF
