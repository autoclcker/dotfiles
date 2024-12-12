#!/usr/bin/env bash

XDG_CONFIG_HOME=${XDG_CONFIG_HOME:-$HOME/.config}

MISE_BACKENDS_PATH=${PWD}/.config/mise/conf.d/backends.toml
MISE_TOOLS_PATH=${PWD}/.config/mise/config.toml

export PATH="${HOME}/.local/bin:$PATH"
export MISE_TRUSTED_CONFIG_PATHS="${MISE_BACKENDS_PATH}:${MISE_TOOLS_PATH}"

set -o errexit  # abort on nonzero exitstatus
set -o nounset  # abort on unbound variable

MISE_IGNORED_CONFIG_PATHS="${MISE_TOOLS_PATH}"  mise install --yes
mise install --yes

exit 0
