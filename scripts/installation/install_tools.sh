#!/usr/bin/env bash

# shellcheck disable=SC1091
source "$HOME/.profile"

if [[ ! $(mise --version) ]]; then
  log "${RED}" "Error: mise is not installed\n"
  exit 1
fi

MISE_LOG_LEVEL=error mise install --yes

exit 0
