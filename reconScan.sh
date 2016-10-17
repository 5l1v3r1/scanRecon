#!/bin/bash


if [ -z "$1" ]; then
	echo Usage: $0 targetIP-File
	exit
fi

echo 'Target IPs'
echo -----------------------
cat $1
echo 
echo -----------------------

for ip in $(cat $1);do
	echo start recon for $ip
	read
	gnome-terminal --window-with-profile=Matrix  -e "./nmap.sh $ip"

done


