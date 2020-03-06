#!/bin/bash -u

SCRIPT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null 2>&1 && pwd )"

vm_name=$1
ubuntu_vm=${2:-ubuntu-1804-lts}

qvm-clone $ubuntu_vm $vm_name

sudo $SCRIPT_DIR/setup_network.sh $vm_name
