#!/usr/bin/env bash

set -euo pipefail
# debug
# set -x


# https://nakkaya.com/2012/08/30/create-manage-virtualBox-vms-from-the-command-line/
function create_vm(){
  vboxmanage createvm --name "${1}" --register
  vboxmanage modifyvm "${1}" --memory 2048 --acpi on
  vboxmanage modifyvm "${1}" --cpus 2
  vboxmanage modifyvm "${1}" --vram 20
  vboxmanage modifyvm "${1}" --graphicscontroller vmsvga
  vboxmanage modifyvm "${1}" --nic1 nat
  vboxmanage modifyvm "${1}" --ostype Linux26_64
  vboxmanage storagectl "${1}" --name "ide_controller" --add ide
  vboxmanage storageattach "${1}" --storagectl "ide_controller"  --port 0 --device 0 --type hdd --medium "${2}"
}

function export_vm(){
  vboxmanage export "${1}" -o "${1}-vbox.ova"
}

function remove_vm(){
  vboxmanage unregistervm "${1}" --delete
}


function main(){
  VM_NAME="${1}"
  if [[ $# -eq 2 ]] ; then
    vm_hdd_path="${2}"
  fi
  if [[ $# -eq 1 ]] ; then
    remove_vm "${VM_NAME}"
  else
    create_vm "${VM_NAME}" "${vm_hdd_path}"
    sleep 3
    export_vm "${VM_NAME}" "${vm_hdd_path}"

  fi
}
main "${@}"
