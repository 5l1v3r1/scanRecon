#!/bin/bash

if [ -z "$1" ]; then
	echo Usage: $0 ip 
	exit
fi


USERPASS=$PWD/user-pass
DIRECTORY=$PWD/nmap-results/$1

if [ ! -d "$DIRECTORY/ftp" ]; then
	mkdir -p $DIRECTORY/ftp
fi

echo "##############################################################################"
echo "ENUMRATE FTP $1"
echo "##############################################################################"
for ftp_port in $(grep ftp $DIRECTORY/tcp.nmap | grep open | cut -d" " -f1 | cut -d"/" -f1) ;do

	echo "[*]RUN nmap scripts on $1:$ftp_port"
	nmap -T1 -n -sV -Pn -vv -p $ftp_port --script=ftp-anon,ftp-bounce,ftp-libopie,ftp-proftpd-backdoor,ftp-vsftpd-backdoor,ftp-vuln-cve2010-4221 -oN $DIRECTORY/ftp/nmap_scripts_$ftp_port $1	
	echo
	echo

	echo "[*]RUN hydra on $1:$ftp_port"
	hydra -vV -f -C $USERPASS -o $DIRECTORY/ftp/found_cred_$ftp_port ftp://$1 -s $ftp_port
 	echo
	echo

done


echo Done
read