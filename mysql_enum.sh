#!/bin/bash

if [ -z "$1" ]; then
	echo Usage: $0 ip 
	exit
fi



DIRECTORY=$PWD/nmap-results/$1

if [ ! -d "$DIRECTORY/mysql" ]; then
	mkdir -p $DIRECTORY/mysql
fi

echo "##############################################################################"
echo "ENUMRATE MYSQL $1"
echo "##############################################################################"
for mysql_port in $(grep mysql $DIRECTORY/tcp.nmap | grep open | cut -d" " -f1 | cut -d"/" -f1) ;do
	echo "[*]RUN nmap script (Non cred) on $1:$mysql_port"
	nmap -Pn -T1 -sV -vv --script=mysql-empty-password,mysql-vuln-cve2012-2122 -p $mysql_port -oN $DIRECTORY/mysql/embty-pass_script_$mysql_port $1
	echo
	echo



	



done


echo Done
read