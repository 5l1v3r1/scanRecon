#!/bin/bash

if [ -z "$1" ]; then
	echo Usage: $0 ip 
	exit
fi



DIRECTORY=$PWD/nmap-results/$1

if [ ! -d "$DIRECTORY/http" ]; then
	mkdir -p $DIRECTORY/http
fi

echo "##############################################################################"
echo "ENUMRATE HTTP $1"
echo "##############################################################################"
for http_port in $(grep ' http ' $DIRECTORY/tcp.nmap | grep open | cut -d" " -f1 | cut -d"/" -f1) ;do
	
	echo "[*]RUN gobuster (common.txt) on $1:$http_port"
	gobuster -t 20 -u http://$1:$http_port/  -w /usr/share/seclists/Discovery/Web_Content/common.txt   -s '200,204,301,302,307,403,500' -e | tee $DIRECTORY/http/gobuster_common_$http_port
	echo
	echo

	echo "[*]RUN nmap scripts on $1:$http_port"
    nmap -T2 -sV -Pn -vv -p $http_port --script=http-vhosts,http-userdir-enum,http-apache-negotiation,http-iis-webdav-vuln,http-backup-finder,http-config-backup,http-default-accounts,http-methods,http-method-tamper,http-passwd,http-robots.txt -oN $DIRECTORY/http/nmap_scripts_$http_port $1
	echo
	echo

	echo "[*]RUN nikto on $1:$http_port"
	nikto -h $1 -p $http_port -output $DIRECTORY/http/nikto_$http_port.txt
	echo
	echo
done


echo Done
read