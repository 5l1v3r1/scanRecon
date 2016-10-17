#!/bin/bash

if [ -z "$1" ]; then
	echo Usage: $0 ip 
	exit
fi



DIRECTORY=$PWD/nmap-results/$1

if [ ! -d "$DIRECTORY/smb" ]; then
	mkdir -p $DIRECTORY/smb
fi

echo "##############################################################################"
echo "ENUMRATE SMB $1"
echo "##############################################################################"
for smb_port in $(grep microsoft-ds $DIRECTORY/tcp.nmap | grep open | cut -d" " -f1 | cut -d"/" -f1) ;do


	echo "[*]RUN nmap scripts on $1:$smb_port"
	nmap -vv -Pn -T2 -p$smb_port --script=smb-enum-domains,smb-enum-groups,smb-enum-processes,smb-enum-sessions,smb-enum-shares,smb-enum-users,smb-os-discovery,smb-print-text,smb-security-mode,smb-server-stats,smb-system-info,smb-vuln-cve2009-3103,smb-vuln-ms06-025,smb-vuln-ms07-029,smb-vuln-ms08-067,smb-vuln-ms10-054,smb-vuln-ms10-061 -oN $DIRECTORY/smb/nmap_scripts_$smb_port $1
	echo
	echo

	echo "[*]RUN enum4linux on $1:$smb_port"
	enum4linux -a $1 | tee $DIRECTORY/smb/enum4linux_$smb_port
	echo
	echo
done


echo Done
read