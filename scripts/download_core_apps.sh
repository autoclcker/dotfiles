#!/usr/bin/env bash

# shellcheck disable=SC1091
source "scripts/helpers.sh"

PACKAGES=()

DOCKER_SBOM_URL=${DOCKER_SBOM_URL:-"https://raw.githubusercontent.com/docker/sbom-cli-plugin/main/install.sh"}
DOCKER_SLIM_URL=${DOCKER_SLIM_URL:-"https://raw.githubusercontent.com/slimtoolkit/slim/master/scripts/install-slim.sh"}
MISE_URL=${MISE_URL:-"https://mise.run"}
OH_MY_ZSH_URL=${OH_MY_ZSH_URL:-"https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh"}
YAY_URL=${YAY_URL:-"https://aur.archlinux.org/yay.git"}

ZSH=${ZSH:-"$HOME/.oh-my-zsh"}

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
    log "${RED}" "Illegal argument: ${1}"
    exit 1
    ;;
  esac
done

sudo pacman --refresh --sync
if [[ ${#PACKAGES[@]} -gt 0 ]]; then
  sudo pacman --needed --noconfirm --sync "${PACKAGES[@]}"
  sudo setfacl --recursive --modify "u:$(whoami):rwx" /etc/pacman.d/gnupg
fi

# Yay
if [[ ! $(yay --version) ]] && [[ "$FULL_INSTALLATION" == true ]]; then
  git clone "${YAY_URL}" /tmp/yay
  pushd "$_" || exit 1
  makepkg --install --noconfirm --syncdeps
else
  log "${CYAN}" "Yay isn't needed\n"
fi

# Zsh
if [[ $(zsh --version) ]] && [[ ! -d "${ZSH}" ]]; then
  sh -c "$(curl --fail --silent --show-error --location "$OH_MY_ZSH_URL")"
else
  log "${CYAN}" "Zsh isn't needed\n"
fi

# Docker
if [[ ! $(slim --version) ]] && [[ "$FULL_INSTALLATION" == true ]]; then
  sudo usermod --append --groups docker "${USER}"
  sudo mkdir --parents /etc/docker && sudo touch "$_/daemon.json"
  sudo tee /etc/docker/daemon.json <<EOF
{
  "features": {
    "cdi": true,
    "containerd-snapshotter": true
  }
}
EOF
  mkdir --parents "$HOME/.docker"
  curl --silent --location --fail --show-error "$DOCKER_SBOM_URL" | sh -s -- # install the docker-sbom plugin
  curl --silent --location "$DOCKER_SLIM_URL" | sudo --preserve-env sh -     # install the docker-slim
else
  log "${CYAN}" "Docker isn't needed\n"
fi

# Mise
if [[ ! $(mise --version) ]]; then
  curl "$MISE_URL" | sh
else
  log "${CYAN}" "Mise isn't needed\n"
fi

exit 0
