#!/bin/bash

if [ -z "$1" ]; then
	echo Usage: $0 ip 
	exit
fi



DIRECTORY=$PWD/nmap-results/$1
USERS_PATH=$PWD/users-offsec


if [ ! -d "$DIRECTORY/smtp" ]; then
	mkdir -p $DIRECTORY/smtp
fi

echo "##############################################################################"
echo "ENUMRATE SMTP $1"
echo "##############################################################################"
for smtp_port in $(grep smtp $DIRECTORY/tcp.nmap | grep open | cut -d" " -f1 | cut -d"/" -f1) ;do

	echo "[*]RUN nmap scripts on $1:$smtp_port"
	nmap -sV -T2 -Pn -vv -p $smtp_port --script=smtp-* -oN $DIRECTORY/smtp/nmap_scripts_$smtp_port $1	
	echo
	echo

	echo "[*]RUN smtp-user-enum on $1:$smtp_port"
	python /root/Desktop/Scripts/smtp.py $1
	echo
	echo	 


done


echo Done
read