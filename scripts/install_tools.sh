#!/usr/bin/env bash

set -o errexit  # abort on nonzero exitstatus
set -o nounset  # abort on unbound variable
set -o pipefail # don't hide errors within pipes

source ~/.profile
mise trust --all

find "$XDG_CONFIG_HOME/mise/conf.d" -type f -name "*.toml" -exec sh -c 'sed --quiet "s/ = /@/gp" {} | xargs -I {} mise install {} --yes' \;

mise install --yes

exit 0
