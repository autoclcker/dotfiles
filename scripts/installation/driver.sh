#!/usr/bin/env bash

# shellcheck disable=SC2034,SC2329

set -a          # enable auto-export
set -o errexit  # abort on nonzero exitstatus
set -o nounset  # abort on unbound variable
set -o pipefail # don't hide errors within pipes

readonly CYAN="\x1B[1;36m"
readonly GREEN="\x1B[1;32m"
readonly RED="\x1B[1;31m"
readonly RESET="\x1B[0m"
readonly YELLOW="\x1B[1;33m"

CONNECTION_TIMEOUT_SEC=${CONNECTION_TIMEOUT_SEC:-10}
IS_FULL_INSTALLATION=${IS_FULL_INSTALLATION:-true}

log() {
  printf "%b" "${1}[!]${RESET} ${2}"
}

log_completion() {
  local exit_code=$?
  if [[ "$exit_code" -eq 0 ]]; then
    log "${GREEN}" "SUCCESS\n"
  else
    log "${RED}" "Error: $0 failed with exit code $exit_code\n"
  fi
}

log_interruption() {
  log "${YELLOW}" "Info: $0 was interrupted\n"
  exit 130
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

  exec "$script_path" "$@"
}

main "$@"
