#!/usr/bin/env bash

SEARCHPATH=${SEARCHPATH:=''}
DESTINATION=${DESTINATION:=''}
POSITIONAL_ARGS=()

while [[ $# -gt 0 ]]; do
  case ${1} in
  -s | --searchpath)
    SEARCHPATH=$(realpath --canonicalize-existing "${2}") || exit 1
    shift # past argument
    shift # past value
    ;;
  -d | --destination)
    DESTINATION=$(realpath --canonicalize-missing "${2}") || exit 1
    shift # past argument
    shift # past value
    ;;
  -h | --help)
    log "${CYAN}" "USAGE:\n ${0} -s searchpath -d destination file_or_directory1 file_or_directory2"
    exit 0
    ;;
  -*)
    log "${RED}" "Error: ${1} is an invalid argument\n"
    exit 1
    ;;
  *)
    POSITIONAL_ARGS+=("${1}") # save positional arg
    shift                     # past argument
    ;;
  esac
done

if [[ -z ${SEARCHPATH} ]]; then
  log "${RED}" "Error: No searchpath provided\n    Use (-s|--searchpath) option to set the path\n"
  exit 1
elif [[ -z ${DESTINATION} ]]; then
  log "${RED}" "Error: No destination provided\n    Use (-d|--destination) option to set the path\n"
  exit 1
else
  log "${CYAN}" "Synchronization started (${SEARCHPATH} -> ${DESTINATION}):\n"
  trap log_completion EXIT
  trap log_interruption INT
fi

mkdir --parents "${DESTINATION}"
for a in "${POSITIONAL_ARGS[@]}"; do
  if [[ -e ${DESTINATION}/${a} ]] && [[ ! -L ${DESTINATION}/${a} ]]; then
    rm --force --recursive "${DESTINATION:?}/${a}"
    log "$YELLOW" "Path was deleted: ${DESTINATION}/${a}]\n"
  fi
done

# shellcheck disable=SC2164
pushd "${SEARCHPATH}" >/dev/null
for a in "${POSITIONAL_ARGS[@]}"; do
  if [[ ! -e ${PWD}/${a} ]]; then
    log "${RED}" "Error: Path does not exists: ${PWD}/${a}]\n"
    continue
  fi
  ln --symbolic --force "${PWD}/${a}" "${DESTINATION}"
  log "${GREEN}" "${DESTINATION}/${a} updated\n"
done

exit 0
