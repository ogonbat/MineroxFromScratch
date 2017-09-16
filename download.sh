#!/usr/bin/env bash

function DOWNLOAD() {
    # check if the base folder source exist
    local temporary_folder=./sources/
    if [ ! -d "$temporary_folder" ]; then
        mkdir -v $temporary_folder
    fi
    wget --input-file=wget-list --continue --directory-prefix="$temporary_folder"
    md5sum -c md5sums
}

DOWNLOAD