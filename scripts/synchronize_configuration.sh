#!/usr/bin/env bash

CYAN="\x1B[36m"
GREEN="\x1B[32m"
RED="\x1B[31m"
RESET="\x1B[0m"
YELLOW="\x1B[33m"

SEARCHPATH=${SEARCHPATH:=''}
DESTINATION=${DESTINATION:=''}
POSITIONAL_ARGS=()

set -o errexit  # abort on nonzero exitstatus
set -o nounset  # abort on unbound variable
set -o pipefail # don't hide errors within pipes

function log {
	printf "$1[!]${RESET} $2"
}

while [[ $# -gt 0 ]]; do
	case ${1} in
	-s | --searchpath)
		SEARCHPATH=${2}
		shift # past argument
		shift # past value
		;;
	-d | --destination)
		DESTINATION=${2}
		shift # past argument
		shift # past value
		;;
	-h | --help)
		log "$CYAN" "USAGE:\n $0 -s searchpath -d destination file_or_directory1 file_or_directory2"
		exit 0
		;;
	-* | --*)
		log "$RED" "Illegal argument: ${1}"
		exit 1
		;;
	*)
		POSITIONAL_ARGS+=(${1}) # save positional arg
		shift                   # past argument
		;;
	esac
done

if [[ -z ${SEARCHPATH} ]]; then
	log "$RED" "No searchpath provided\nUse (-s|--searchpath) flag to set the path"
	exit 1
fi
if [[ -z ${DESTINATION} ]]; then
	log "$RED" "No destination provided\nUse (-d|--destination) flag to set the path"
	exit 1
fi

for a in ${POSITIONAL_ARGS[*]}; do
	if [[ -e ${DESTINATION}/${a} ]] && [[ ! -L ${DESTINATION}/${a} ]]; then
		rm --force --recursive ${DESTINATION}/${a}
		log "$YELLOW" "Path was deleted: ${DESTINATION}/${a}]\n"
	fi
done
pushd ${SEARCHPATH} >/dev/null
for a in ${POSITIONAL_ARGS[*]}; do
	if [[ ! -e ${PWD}/${a} ]]; then
		log "$RED" "Path does not exists: ${PWD}/${a}]\n"
		continue
	fi
	ln --symbolic --force ${PWD}/${a} ${DESTINATION}
	log "$GREEN" "${DESTINATION}/${a} updated\n"
done
popd >/dev/null

exit 0
