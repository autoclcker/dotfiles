#!/usr/bin/env bash

INSTALL_DOCKER=${INSTALL_DOCKER:=true}
INSTALL_UBUNTU=$(awk -F= '/^NAME/{print $2}' /etc/os-release | grep Ubuntu)

# IMPORTANT: This script is only for Debian/Ubuntu
set -o errexit  # abort on nonzero exitstatus
set -o nounset  # abort on unbound variable
set -o pipefail # don't hide errors within pipes

if [ $# -ne 1 ]; then
  printf "Error: Invalid number of arguments"
  exit 1
fi

sudo apt-get update
xargs -a "$1" sudo apt-get install --yes

# Install Docker
if [[ ! -f /etc/apt/sources.list.d/docker.list ]] && [[ "$INSTALL_DOCKER" == true ]]; then
  curl -s https://get.docker.com | sh
  sudo usermod -aG docker "${USER}" && newgrp docker
  sudo systemctl enable docker.service
  sudo systemctl enable containerd.service
else
  printf "\e[1;96m%s\e[0m\n" "Docker isn't needed"
fi

# Install Mise
curl https://mise.run | sh

# Install VSCodium
if [[ ! -f /etc/apt/sources.list.d/vscodium.list ]]; then
  wget -qO - https://gitlab.com/paulcarroty/vscodium-deb-rpm-repo/raw/master/pub.gpg |
    gpg --dearmor |
    sudo dd of=/usr/share/keyrings/vscodium-archive-keyring.gpg
  echo 'deb [ signed-by=/usr/share/keyrings/vscodium-archive-keyring.gpg ] https://download.vscodium.com/debs vscodium main' |
    sudo tee /etc/apt/sources.list.d/vscodium.list
  sudo apt-get update && sudo apt install codium --yes
else
  printf "\e[1;96m%s\e[0m\n" "VSCodium is already installed"
fi

# Install CopyQ
if [[ ! -f /etc/apt/sources.list.d/hluk-ubuntu-copyq-jammy.list ]] && [[ "$INSTALL_UBUNTU" != "" ]]; then
  sudo add-apt-repository ppa:hluk/copyq
  sudo apt-get update && sudo apt install copyq --yes
else
  printf "\e[1;96m%s\e[0m\n" "CopyQ isn't needed"
fi

exit 0
