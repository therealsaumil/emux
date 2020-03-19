#!/usr/bin/env bash

set -e


# https://nakkaya.com/2012/08/30/create-manage-virtualBox-vms-from-the-command-line/
function create_vm(){
  VBoxManage createvm --name "${1}" --register
  VBoxManage modifyvm "${1}" --memory 512 --acpi on
  VBoxManage modifyvm "${1}" --nic1 nat
  VBoxManage modifyvm "${1}" --ostype Linux26_64
  VBoxManage storagectl "${1}" --name "ide_controller" --add ide
  VBoxManage storageattach "${1}" --storagectl "ide_controller"  --port 0 --device 0 --type hdd --medium "${2}"
}

function export_vm(){
  vboxmanage export "${1}" -o "${1}-vbox.ova"
}

function remove_vm(){
  vm_folder="$(vboxmanage showvminfo "${1}" --machinereadable | grep -i 'sata-0' | cut -d '=' -f 2 | tr -d '"' | rev | cut -d '/' -f 2- | rev)"
  vboxmanage unregistervm "${1}" --delete
  rm -rf ${vm_folder}
  rm "${1}-vbox.ova"
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
