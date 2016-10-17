#!/bin/bash

if [ -z "$1" ]; then
	echo Usage: $0 ip 
	exit
fi



DIRECTORY=$PWD/nmap-results/$1

if [ ! -d "$DIRECTORY/https" ]; then
	mkdir -p $DIRECTORY/https
fi

echo "##############################################################################"
echo "ENUMRATE HTTPS $1"
echo "##############################################################################"
for https_port in $(grep -e https -e ssl/http $DIRECTORY/tcp.nmap | grep open | cut -d" " -f1 | cut -d"/" -f1) ;do
	
	echo "[*]RUN gobuster (common.txt) on $1:$https_port"
	gobuster -t 20 -u https://$1:$https_port/  -w /usr/share/seclists/Discovery/Web_Content/common.txt   -s '200,204,301,302,307,403,500' -e | tee $DIRECTORY/https/gobuster_common_$https_port
	echo
	echo

	echo "[*]RUN nmap scripts on $1:$https_port"
    nmap -T2 -sV -Pn -vv -p $https_port --script=http-vhosts,http-userdir-enum,http-apache-negotiation,http-iis-webdav-vuln,http-backup-finder,http-config-backup,http-default-accounts,http-methods,http-method-tamper,http-passwd,http-robots.txt -oN $DIRECTORY/https/nmap_scripts_$https_port $1
	echo
	echo

	echo "[*]RUN nikto on $1:$https_port"
	nikto -h https://$1:$https_port -output $DIRECTORY/https/nikto_$https_port.txt
	echo
	echo
done


echo Done
read