#!/usr/bin/env bash

# shellcheck disable=SC1091
source "$HOME/.profile"

PACKAGES=()

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

if [[ ! $(mise --version) ]]; then
  log "${RED}" "Error: mise is not installed\n"
  exit 1
fi

if [[ ! $(yay --version) ]] && [[ ${#PACKAGES[@]} -gt 0 ]]; then
  log "${RED}" "Error: yay is not installed\n"
  exit 1
elif [[ ${#PACKAGES[@]} -gt 0 ]]; then
  yay --refresh --sync
  yay --needed --noconfirm --removemake --sync "${PREREQUISITES[@]}"
  yay --needed --noconfirm --removemake --sync "${PACKAGES[@]}"
fi

MISE_LOG_LEVEL=error mise install --yes

exit 0
