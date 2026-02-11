#!/usr/bin/env bash

# shellcheck disable=SC2034

set -a          # enable auto-export
set -o errexit  # abort on nonzero exitstatus
set -o nounset  # abort on unbound variable
set -o pipefail # don't hide errors within pipes

readonly CYAN="\x1B[1;36m"
readonly GREEN="\x1B[1;32m"
readonly RED="\x1B[1;31m"
readonly RESET="\x1B[0m"
readonly YELLOW="\x1B[1;33m"

FULL_INSTALLATION=${FULL_INSTALLATION:-true}

log() {
  printf "%b" "${1}[!]${RESET} ${2}"
}

print_usage() {
  local commands=() sorted=()
  local scripts_dir usage_msg

  scripts_dir="$(dirname "$0")"
  for f in "$scripts_dir"/*.sh; do
    [[ "$0" != "$f" ]] || continue
    [[ -f "$f" ]] || continue
    local name
    name=$(basename "$f")
    name="${name%.sh}"
    commands+=("$name")
  done

  read -ra sorted <<<"$(sort <<<"${commands[*]}")"
  usage_msg="$(printf "      %s\n" "${sorted[@]}")"
  usage_msg="\
Usage: $0 <command> [args...]
    Available commands:
$usage_msg
"

  log "${CYAN}" "$usage_msg"
}

main() {
  if [[ $# -eq 0 ]]; then
    log "${RED}" "Error: Missing script argument\n"
    print_usage
    exit 1
  fi

  local script_dir script_path
  local script_name="$1"

  script_dir="$(dirname "$0")"
  script_name="${script_name%.sh}"
  script_path="$script_dir/$script_name.sh"

  if [[ ! -f "$script_path" ]]; then
    log "${RED}" "Error: Command '$script_name' not found\n"
    print_usage
    exit 1
  fi

  shift # Remove script name from arguments

  "$script_path" "$@"
}

main "$@"

exit 0
