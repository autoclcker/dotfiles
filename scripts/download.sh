#!/usr/bin/env bash

# IMPORTANT: This script is only for Debian/Ubuntu
set -o errexit  # abort on nonzero exitstatus
set -o nounset  # abort on unbound variable
set -o pipefail # don't hide errors within pipes

# Install Docker
curl -s https://get.docker.com | sh

sudo groupadd docker
sudo usermod -aG docker "${USER}"
newgrp docker

sudo systemctl enable docker.service
sudo systemctl enable containerd.service

# Install Mise
sudo apt install pkg-config libfreetype6-dev libfontconfig1-dev libxcb-xfixes0-dev libxkbcommon-dev
curl https://mise.run | sh

# Install VSCodium
wget -qO - https://gitlab.com/paulcarroty/vscodium-deb-rpm-repo/raw/master/pub.gpg \
    gpg --dearmor \
    sudo dd of=/usr/share/keyrings/vscodium-archive-keyring.gpg
echo 'deb [ signed-by=/usr/share/keyrings/vscodium-archive-keyring.gpg ] https://download.vscodium.com/debs vscodium main' \
    sudo tee /etc/apt/sources.list.d/vscodium.list
sudo apt update && sudo apt install codium
