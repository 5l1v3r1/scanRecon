#!/bin/bash

if [ -z "$1" ]; then
	echo Usage: $0 ip 
	exit
fi


SNMP_PASS=$PWD/snmp_default_pass.txt
DIRECTORY=$PWD/nmap-results/$1

if [ ! -d "$DIRECTORY/snmp" ]; then
	mkdir -p $DIRECTORY/snmp
fi

echo "##############################################################################"
echo "ENUMRATE SNMP $1"
echo "##############################################################################"
for snmp_port in $(grep snmp $DIRECTORY/udp.nmap | grep open | cut -d" " -f1 | cut -d"/" -f1) ;do
	
	echo "[*]RUN onesixtyone (common.txt) on $1:$snmp_port"
	onesixtyone -c $SNMP_PASS $1 | tee $DIRECTORY/snmp/onesixtyone
	echo
	echo




	echo "[*]RUN snmp-check on $1:$snmp_port"
	snmp-check -t $1 -p $snmp_port -c public | tee $DIRECTORY/snmp/snmp-check
	echo
	echo

	echo "[*]RUN snmpWALK on $1:$snmp_port"
	snmpwalk -c public -v1 $1 | tee $DIRECTORY/snmp/snmpwalk
	echo
	echo	

done


echo Done
read