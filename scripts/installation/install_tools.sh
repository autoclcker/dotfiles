#!/usr/bin/env bash

# shellcheck disable=SC1091
source "$HOME/.profile"

MISE_CONF_DIR=${MISE_CONF_DIR:-"${PWD}/.config/mise/conf.d"}
MISE_CONF_PATH=${MISE_CONF_PATH:-"${PWD}/.config/mise/config.toml"}

if [[ ! $(mise --version) ]]; then
  log "${RED}" "Error: mise is not installed\n"
  exit 1
fi

MISE_QUIET=true mise --cd "${MISE_CONF_DIR}" trust
MISE_IGNORED_CONFIG_PATHS="$MISE_CONF_PATH" mise install --yes
mise install --yes

exit 0
