#!/usr/bin/env bash

MISE_CONF_DIR=${MISE_CONF_DIR:-"${PWD}/.config/mise/conf.d"}
MISE_CONF_PATH=${MISE_CONF_PATH:-"${PWD}/.config/mise/config.toml"}

export PATH="${HOME}/.local/bin:$PATH"

set -o errexit # abort on nonzero exitstatus
set -o nounset # abort on unbound variable

MISE_QUIET=true mise --cd "${MISE_CONF_DIR}" trust
MISE_IGNORED_CONFIG_PATHS="$MISE_CONF_PATH" mise install --yes
mise install --yes

exit 0
