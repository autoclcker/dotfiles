#!/usr/bin/env bash

PACKAGES=${PACKAGES:=''}

INSTALL_DOCKER=${INSTALL_DOCKER:-true}

DOCKER_SBOM_URL=${DOCKER_SBOM_URL:-"https://raw.githubusercontent.com/docker/sbom-cli-plugin/main/install.sh"}
DOCKER_URL=${DOCKER_URL:-"https://get.docker.com/"}
MISE_URL=${MISE_URL:-"https://mise.run"}
VSCODIUM_URL=${VSCODIUM_URL:-"https://download.vscodium.com"}

VSCODIUM_REPO=${VSCODIUM_REPO:-"https://gitlab.com/paulcarroty/vscodium-deb-rpm-repo"}

# IMPORTANT: This script is only for Ubuntu-based distro
set -o errexit  # abort on nonzero exitstatus
set -o nounset  # abort on unbound variable
set -o pipefail # don't hide errors within pipes

while [[ $# -gt 0 ]]; do
  case ${1} in
  -p | --packages)
    PACKAGES=${2}
    shift # past argument
    shift # past value
    ;;
  esac
done

sudo apt-get update
if [[ "$PACKAGES" ]]; then
  xargs --arg-file "$PACKAGES" sudo apt-get install --yes
fi

# Install Docker
if [[ ! -f /etc/apt/sources.list.d/docker.list ]] && [[ "$INSTALL_DOCKER" == true ]]; then
  curl --silent "$DOCKER_URL" | sh
  sudo usermod --append --groups docker "${USER}" && newgrp docker
  sudo setfacl -m "u:${USER}:rwx" /etc/docker/daemon.json
  cat <<EOF >>/etc/docker/daemon.json
{
  "features": {
    "containerd-snapshotter": true
  }
}
EOF
  sudo systemctl enable docker.service
  sudo systemctl enable containerd.service
  curl --silent --location --fail --show-error "$DOCKER_SBOM_URL" | sh --silent -- # install the docker-sbom plugin
else
  printf "\e[1;96m%s\e[0m\n" "Docker isn't needed"
fi

# Install Mise
curl "$MISE_URL" | sh

# Install VSCodium
if [[ ! -f /etc/apt/sources.list.d/vscodium.list ]]; then
  wget -qO - "$VSCODIUM_REPO/raw/master/pub.gpg" |
    gpg --dearmor |
    sudo dd of=/usr/share/keyrings/vscodium-archive-keyring.gpg
  echo "deb [ signed-by=/usr/share/keyrings/vscodium-archive-keyring.gpg ] $VSCODIUM_URL/debs vscodium main" |
    sudo tee /etc/apt/sources.list.d/vscodium.list
  sudo apt-get update && sudo apt install codium --yes
else
  printf "\e[1;96m%s\e[0m\n" "VSCodium is already installed"
fi

# Install CopyQ
if [[ ! -f /etc/apt/sources.list.d/hluk-ubuntu-copyq-jammy.list ]]; then
  sudo add-apt-repository ppa:hluk/copyq
  sudo apt-get update && sudo apt install copyq --yes
else
  printf "\e[1;96m%s\e[0m\n" "CopyQ is already installed"
fi

exit 0
