#!/bin/bash -u

vm_sync=$1
sync_path=$2
dest=${3:-$PWD}

for f in $(qvm-run --pass-io $vm_sync "ls $sync_path"); do
	read -p "Do you want to copy $vm_sync:$sync_path/$f to $dest/$f? (y/n)" ans
	if [[ $ans == "y" ]]; then
	       qvm-run --pass-io $vm_sync "cat $sync_path/$f" > $dest/$f	
       fi
done
