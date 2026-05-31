#!/usr/bin/env bash

# shellcheck disable=SC1091
[ -f "$HOME/.profile" ] && source "$HOME/.profile"

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
    log "${RED}" "Error: ${1} is an invalid argument\n"
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
if [[ ! $(yay --version) ]]; then
  git clone --depth 1 https://github.com/autoclcker/dotfiles.git
  git clone  --depth 1 "${YAY_REPO}" /tmp/yay || exit 1
  pushd "$_" || exit 1
  makepkg --install --noconfirm --syncdeps
else
  log "${CYAN}" "Yay isn't needed\n"
fi

# Mise
if [[ ! $(mise --version) ]]; then
  curl --connect-timeout "${CONNECTION_TIMEOUT_SEC}" --fail "$MISE_URL" | \
      MISE_INSTALL_FROM_GITHUB=1 timeout "${CONNECTION_TIMEOUT_SEC}" sh || \
      { echo; log "${RED}" "Error: connection timeout exceeded\n"; exit 1; }
else
  log "${CYAN}" "Mise isn't needed\n"
fi

exit 0
