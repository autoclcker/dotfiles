#!/usr/bin/env bash

INSTALL_CYCLES=${INSTALL_CYCLES:-3}
MISE_PATH=${MISE_PATH:-"${PWD}/.config/mise/conf.d"}

export PATH="${HOME}/.local/bin:$PATH"

set -o errexit # abort on nonzero exitstatus
set -o nounset # abort on unbound variable

MISE_QUIET=true mise --cd "${MISE_PATH}" trust
for _ in {1..INSTALL_CYCLES}; do
  MISE_AUTO_INSTALL=false mise install --yes
done

exit 0
