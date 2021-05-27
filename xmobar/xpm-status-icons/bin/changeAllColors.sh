#!/usr/bin/env bash

MAIN_GIT_DIR="$(git rev-parse --show-toplevel)" 

if [ -z "$1" ] ; then
    echo "Give configuration file as first argument. Template is: 'xpm-status-icons/bin/configColors.sh'"
    exit 1
fi

CONFIG_FILE="$1"

source "${MAIN_GIT_DIR}/bin/config/configIconDirs.sh"

echo "Edit XPM files."
for directory in ${DIRS} ; do
    full_path_dir="${MAIN_GIT_DIR}/icons/${directory}"
    for file in "${full_path_dir}/"*".xpm" ; do
        ${MAIN_GIT_DIR}/bin/changeColors.sh "${CONFIG_FILE}" "${file}"
    done
done
