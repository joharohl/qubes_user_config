#!/bin/bash -eu

function send_command() {
    tty=$1
    cmd=$2
    echo "$cmd" > $tty
    sleep 1
}

function on_exit() {
    vm=$1
    cat_pid=$2

    kill $cat_pid

    qvm-shutdown --wait $vm
    qvm-start $vm
}

if [[ "$USER" != "root" ]]; then
    echo "This program has to be run as root!"
    exit 1
fi

vm_name=$1
user_name=${2:-user}
password=${3:-user}
power_on_delay=${POWER_ON_DELAY:-30}
ubuntu_version=${UBUNTU_VERSION:-18.04}

ip=$(qvm-prefs $vm_name ip)
gw=$(qvm-prefs $vm_name visible-gateway)
dns="10.139.1.1"

read -r -d '' config_netplan <<EOF || :
network:
  version: 2
  ethernets:
    eth0:
      addresses:
        - $ip/24
      gateway4: $gw
      nameservers:
        addresses:
          - $dns
EOF


# Make sure the vm is started.
qvm-start --skip-if-running $vm_name
until qvm-check --running $vm_name; do
    sleep 2
done

# Anoying but easiest way to make sure we have a prompt.
sleep $power_on_delay

# Get a tty. The only way (that I know of) that we can do it with VM without qubes
tty=$(virsh -c xen:/// ttyconsole $vm_name)

echo "Using tty $tty"
cat $tty &
cat_pid=$!

trap "on_exit $vm_name $cat_pid" EXIT

send_command $tty $user_name
send_command $tty $password

send_command $tty "sudo su"
send_command $tty $password

if [[ "$ubuntu_version" == "16.04" ]]; then
    read -r -d '' config <<EOF || :
auto lo
iface lo inet loopback

auto eth0
iface eth0 inet static
      address $ip
      netmask 255.255.255.0
      network ${ip%.*}.0
      broadcast ${ip%.*}.255
      gateway $gw
      dns-nameservers $dns
EOF
    send_command $tty "echo \"$config\" > /etc/network/interfaces"
else
    send_command $tty "echo \"$config\" > /etc/netplan/main.yaml"
fi
