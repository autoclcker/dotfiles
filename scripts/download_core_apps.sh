#!/usr/bin/env bash

# shellcheck disable=SC1091
source "scripts/helpers.sh"

PACKAGES=()

MISE_URL=${MISE_URL:-"https://mise.run"}
YAY_REPO=${YAY_REPO:-"https://aur.archlinux.org/yay.git"}

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
if [[ "$FULL_INSTALLATION" == true ]] && [[ ! $(yay --version) ]]; then
  git clone "${YAY_REPO}" /tmp/yay
  pushd "$_" || exit 1
  makepkg --install --noconfirm --syncdeps
else
  log "${CYAN}" "Yay isn't needed\n"
fi

# Mise
if [[ ! $(mise --version) ]]; then
  curl "$MISE_URL" | sh
else
  log "${CYAN}" "Mise isn't needed\n"
fi

exit 0
