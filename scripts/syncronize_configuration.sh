#!/usr/bin/env bash

CYAN="\x1B[36m"
GREEN="\x1B[32m"
RED="\x1B[31m"
RESET="\x1B[0m"

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
		log "$CYAN" "USAGE:\n $0 -s sourcepath -d destination file_or_directory1 file_or_directory2"
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

pushd ${SEARCHPATH} >/dev/null
for a in ${POSITIONAL_ARGS[*]}; do
	if [[ ! -e ${SEARCHPATH}/${a} ]]; then
		log "$RED" "Path does not exists: ${SEARCHPATH}/${a}]\n"
		continue
	fi
	if [[ -d ${a} ]]; then
		rsync --archive --inplace --mkpath --relative ${a} ${DESTINATION}
	else
		rsync --archive --inplace ${a} ${DESTINATION}
	fi
	updated=$(date --reference=${DESTINATION}/${a} "+%Y-%m-%d %H:%M")
	current=$(date "+%Y-%m-%d %H:%M")
	if [[ ${updated} == ${current} ]]; then
		log "$GREEN" "${DESTINATION}/${a} updated\n"
	fi
done
popd >/dev/null

exit 0
