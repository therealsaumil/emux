#!/usr/bin/env bash

set -euo pipefail
# debug
# set -x

##################################################
## variables

# array of dependencies
deps_array=( "unzip" "7z" "packer" )

# link to download the 7z files from
download_link='https://app.box.com/s/3iyi5f6vpakngh8ti3ir2zzukgdu0j2q'

# used during the extraction phase
compressed_folder='./compressed_images'
uncompressed_folder='uncompressed_images'

vm_name="armx"
##################################################

# unzip ARMX-PREVIEW-selected.zip -d ./compressed_images

function deps(){
    for dep in "${deps_array[@]}" ; do
        if ! command -v "${dep}" ; then
            printf 'You are missing %s' "${dep}"
        fi
    done
}

function extraction(){
    rm -rf "${compressed_folder:?}"/* "${uncompressed_folder:?}"/*
    unzip "${archive_file}" -d "${compressed_folder}"
    7z e "${compressed_folder}/armx-march2020.7z.001" -o"${uncompressed_folder}"
}

function vbox_conversion(){
    vm="${1}"
    if [[ -f "./*.ova" ]] ; then
        rm ./*.ova
    fi

    ./vmx-vbox.sh "${vm}" "./${uncompressed_folder}/armx.vmdk"
}

function cleanup(){
    # https://github.com/koalaman/shellcheck/wiki/SC2115
    rm -rf "${compressed_folder:?}"/* "${uncompressed_folder:?}"/*
    ./vmx-vbox.sh "${1}"
}

function main(){

    # checking for dependencies
    deps

    # having user download zip from armx box box link
    printf 'Please download both 001 and 002\nat this url: %s\n\n' "${download_link}"
    # making sure download has finished
    read -rp "Did you download 001 and 002? [Y/n]" continuez

    # ensuring they downloaded both files and exiting if they didn't
    case "${continuez}" in
        N|n)
            printf 'You need to download both parts as this is a two part 7zip file.\n'
            exit 1
    esac

    # asking for the filename of the zip
    read -rp "What is the file name or full path (if not in the same directory) that you saved the .zip file as?(include the .zip (i.e. archive.zip)) " archive_file

    if [[ ! -f "${archive_file}" ]] ; then
        printf 'Unable to find filename given: %s' "${archive_file}"
    fi

    extraction
    vbox_conversion "${vm_name}"
    cleanup "${vm_name}"
}

main
