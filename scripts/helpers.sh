#!/usr/bin/env bash

# shellcheck disable=SC2034

set -o errexit  # abort on nonzero exitstatus
set -o nounset  # abort on unbound variable
set -o pipefail # don't hide errors within pipes

readonly CYAN="\x1B[36m"
readonly GREEN="\x1B[32m"
readonly RED="\x1B[31m"
readonly RESET="\x1B[0m"
readonly YELLOW="\x1B[33m"

FULL_INSTALLATION=${FULL_INSTALLATION:-true}

log() {
  printf "%b" "${1}[!]${RESET} ${2}"
}
