#!/bin/bash

if [ -z "$1" ]; then
	echo Usage: $0 ip 
	exit
fi



DIRECTORY=$PWD/nmap-results/$1

if [ ! -d "$DIRECTORY/mssql" ]; then
	mkdir -p $DIRECTORY/mssql
fi

echo "##############################################################################"
echo "ENUMRATE MS-SQL $1"
echo "##############################################################################"

for mssql_port in $(grep ms-sql $DIRECTORY/tcp.nmap | grep open | cut -d" " -f1 | cut -d"/" -f1) ;do


	echo "[*]RUN nmap scripts on $1:$mssql_port"
    nmap -T2  -vv -sV -Pn -p $mssql_port --script=ms-sql-info,ms-sql-config,ms-sql-dump-hashes --script-args=mssql.instance-port=$mssql_port,smsql.username-sa,mssql.password-sa -oN $DIRECTORY/mssql/nmap_scripts_$mssql_port $1 
	echo
	echo

done


echo Done
read