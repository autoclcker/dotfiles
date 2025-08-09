#!/usr/bin/env bash

PACKAGES=()

INSTALL_DOCKER=${INSTALL_DOCKER:-true}

DOCKER_SBOM_URL=${DOCKER_SBOM_URL:-"https://raw.githubusercontent.com/docker/sbom-cli-plugin/main/install.sh"}
DOCKER_SLIM_URL=${DOCKER_SLIM_URL:-"https://raw.githubusercontent.com/slimtoolkit/slim/master/scripts/install-slim.sh"}
DOCKER_URL=${DOCKER_URL:-"https://get.docker.com/"}
GHOSTTY_URL=${GHOSTTY_URL:-"https://raw.githubusercontent.com/mkasberg/ghostty-ubuntu/HEAD/install.sh"}
MISE_URL=${MISE_URL:-"https://mise.run"}
OH_MY_ZSH_URL=${OH_MY_ZSH_URL:-"https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh"}
VSCODIUM_URL=${VSCODIUM_URL:-"https://download.vscodium.com"}

VSCODIUM_REPO=${VSCODIUM_REPO:-"https://gitlab.com/paulcarroty/vscodium-deb-rpm-repo"}

# IMPORTANT: This script is only for Ubuntu-based distro
set -o errexit  # abort on nonzero exitstatus
set -o nounset  # abort on unbound variable
set -o pipefail # don't hide errors within pipes

while [[ $# -gt 0 ]]; do
  case ${1} in
  -p | --packages)
    PACKAGES+=("${2}")
    shift # past argument
    shift # past value
    while [[ $# -gt 0 ]] && [[ ! "${1}" =~ ^-.* ]]; do
      PACKAGES+=("${1}")
      shift
    done
    ;;
  -*)
    printf "%b %s\n" "\x1B[31mIllegal argument:\x1B[0m" "${1}"
    exit 1
    ;;
  esac
done

sudo apt-get update
if [[ ${#PACKAGES[@]} -gt 0 ]]; then
  sudo apt-get install --yes "${PACKAGES[@]}"
fi

# Install Docker
if [[ ! -f /etc/apt/sources.list.d/docker.list ]] && [[ "$INSTALL_DOCKER" == true ]]; then
  curl --silent "$DOCKER_URL" | sh
  sudo usermod --append --groups docker "${USER}" && newgrp docker
  sudo setfacl -m "u:${USER}:rwx" /etc/docker/daemon.json
  cat <<EOF >/etc/docker/daemon.json
{
  "features": {
    "cdi": true,
    "containerd-snapshotter": true
  }
}
EOF
  sudo systemctl enable docker.service
  sudo systemctl enable containerd.service
  curl --silent --location --fail --show-error "$DOCKER_SBOM_URL" | sh --silent -- # install the docker-sbom plugin
  curl --silent --location "$DOCKER_SLIM_URL" | sudo --preserve-env sh -           # install the docker-slim
else
  printf "\e[1;96m%s\e[0m\n" "Docker isn't needed"
fi

# Install Mise
curl "$MISE_URL" | sh

# Install VSCodium
if [[ ! -f /etc/apt/sources.list.d/vscodium.list ]] && [[ "$INSTALL_DOCKER" == true ]]; then
  wget -qO - "$VSCODIUM_REPO/raw/master/pub.gpg" \
    | gpg --dearmor \
    | sudo dd of=/usr/share/keyrings/vscodium-archive-keyring.gpg
  printf "deb [arch=amd64,arm64 signed-by=/usr/share/keyrings/vscodium-archive-keyring.gpg] %s/debs vscodium main" "$VSCODIUM_URL" \
    | sudo tee /etc/apt/sources.list.d/vscodium.list
  sudo apt-get update && sudo apt install codium --yes
else
  printf "\e[1;96m%s\e[0m\n" "VSCodium is already installed"
fi

# Install CopyQ
if [[ ! -f /etc/apt/sources.list.d/hluk-ubuntu-copyq-jammy.list ]] && [[ "$INSTALL_DOCKER" == true ]]; then
  sudo add-apt-repository ppa:hluk/copyq
  sudo apt-get update && sudo apt install copyq --yes
else
  printf "\e[1;96m%s\e[0m\n" "CopyQ is already installed"
fi

# Install Oh My Zsh
if [[ ! -d "${HOME}/.oh-my-zsh" ]]; then
  sh -c "$(curl --fail --silent --show-error --location "$OH_MY_ZSH_URL")"
else
  printf "\e[1;96m%s\e[0m\n" "Oh My Zsh is already installed"
fi

# Install Ghostty
if [[ ! $(ghostty --version) ]]; then
  bash -c "$(curl --fail --silent --show-error --location "$GHOSTTY_URL")"
else
  printf "\e[1;96m%s\e[0m\n" "Ghostty is already installed"
fi

exit 0
