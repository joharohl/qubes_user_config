#!/bin/bash -u

SCRIPT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null 2>&1 && pwd )"

vm_name=$1
ubuntu_vm=${2:-ubuntu-1804-lts}

if [[ $ubuntu_vm == "ubuntu-1604-lts" ]]; then
    ubuntu_version=16.04
elif [[ $ubuntu_vm == "ubuntu-1804-lts" ]]; then
    ubuntu_version=18.04
fi

qvm-clone $ubuntu_vm $vm_name

sudo UBUNTU_VERSION=$ubuntu_version $SCRIPT_DIR/setup_network.sh $vm_name
