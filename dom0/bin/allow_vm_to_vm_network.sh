#!/bin/bash

vm_a=$1
vm_b=$2

vm_firewall=${3:-mullvad-firewall}

ip_a=$(qvm-prefs $vm_a visible_ip)
ip_b=$(qvm-prefs $vm_b visible_ip)

qvm-run -u root $vm_firewall "iptables -I FORWARD 2 -s $ip_a -d $ip_b -j ACCEPT"
qvm-run -u root $vm_b "iptables -I INPUT -s $ip_a -j ACCEPT"
