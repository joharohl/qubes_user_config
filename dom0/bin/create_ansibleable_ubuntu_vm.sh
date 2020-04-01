#!/bin/bash -u

SCRIPT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null 2>&1 && pwd )"

vm_name=$1
ubuntu_template=${2:-bionic}

qvm-create --template $ubuntu_template --label red $vm_name

# Make sure the vm is started.
qvm-start --skip-if-running $vm_name
until qvm-check --running $vm_name; do
    sleep 2
done

qvm-run --pass-io --user root $vm_name "apt update && apt install -y openssh-server"
qvm-run --pass-io --user root $vm_name "echo user:user | chpasswd"

$SCRIPT_DIR/allow_vm_to_vm_network.sh dev $vm_name
