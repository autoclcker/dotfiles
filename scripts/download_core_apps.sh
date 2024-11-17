#!/usr/bin/env bash

# IMPORTANT: This script is only for Debian/Ubuntu
set -o errexit  # abort on nonzero exitstatus
set -o nounset  # abort on unbound variable
set -o pipefail # don't hide errors within pipes

sudo apt update

# Install Docker
if [[ ! -f /etc/apt/sources.list.d/docker.list ]]; then
    curl -s https://get.docker.com | sh
    sudo groupadd docker && sudo usermod -aG docker "${USER}" && newgrp docker
    sudo systemctl enable docker.service
    sudo systemctl enable containerd.service
else
    printf "\e[1;96m%s\e[0m\n" "Docker is already installed"
fi

# Install Mise
sudo apt install pkg-config libfreetype6-dev libfontconfig1-dev libxcb-xfixes0-dev libxkbcommon-dev
curl https://mise.run | sh

# Install VSCodium
if [[ ! -f /etc/apt/sources.list.d/vscodium.list ]]; then
    wget -qO - https://gitlab.com/paulcarroty/vscodium-deb-rpm-repo/raw/master/pub.gpg gpg --dearmor \
        sudo dd of=/usr/share/keyrings/vscodium-archive-keyring.gpg
    echo 'deb [ signed-by=/usr/share/keyrings/vscodium-archive-keyring.gpg ] https://download.vscodium.com/debs vscodium main' \
        sudo tee /etc/apt/sources.list.d/vscodium.list
    sudo apt update && sudo apt install codium
else
    printf "\e[1;96m%s\e[0m\n" "VSCodium is already installed"
fi

# Install CopyQ
if [[ ! -f /etc/apt/sources.list.d/hluk-ubuntu-copyq-jammy.list ]]; then
    sudo apt install software-properties-common python-software-properties
    sudo add-apt-repository ppa:hluk/copyq
    sudo apt update && sudo apt install copyq
else
    printf "\e[1;96m%s\e[0m\n" "CopyQ is already installed"
fi

# Install Fonts
if [[ ! -d /usr/local/share/fonts/nerd-fonts ]]; then
    sudo git clone --depth 1 https://github.com/ryanoasis/nerd-fonts.git /usr/local/share/fonts/nerd-fonts
    pushd "$_" || exit 1
    for a in Hack FiraCode DejaVuSansMono; do
        ./install.sh $a
    done
else
    printf "\e[1;96m%s\e[0m\n" "Fonts are already installed"
fi

exit 0
