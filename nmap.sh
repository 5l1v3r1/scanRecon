#!/bin/bash

if [ -z "$1" ]; then
	echo Usage: $0 ip
	exit
fi


DIRECTORY=$PWD/nmap-results/$1
if [ ! -d "$DIRECTORY" ]; then
	mkdir -p $DIRECTORY
fi


echo "##############################################################################"
echo "TCP SCAN FOR $1"
echo "##############################################################################"

nmap -Pn -p- -sS -vv  -A -oA $DIRECTORY/tcp $1


echo "##############################################################################"
echo "UDP SCAN FOR $1"
echo "##############################################################################"

nmap -Pn -n -sU --top-port 200 -vv -A -oA $DIRECTORY/udp $1

# ENUMRATE SSH
if [[ $(grep ssh $DIRECTORY/tcp.nmap | grep open | cut -d" " -f1 | cut -d"/" -f1) ]];then
	echo "SSH FOUND"
	gnome-terminal --window-with-profile=Matrix  -e "./ssh_enum.sh $1"
fi


# ENUMRATE HTTP
if [[ $(grep ' http ' $DIRECTORY/tcp.nmap | grep open | cut -d" " -f1 | cut -d"/" -f1) ]];then
	echo "HTTP FOUND"
	gnome-terminal --window-with-profile=Matrix  -e "./http_enum.sh $1"
fi

# ENUMRATE HTTPS
if [[ $(grep -e https -e ssl/http $DIRECTORY/tcp.nmap | grep open | cut -d" " -f1 | cut -d"/" -f1) ]];then
	echo "HTTPS FOUND"
	gnome-terminal --window-with-profile=Matrix  -e "./https_enum.sh $1"
fi

# ENUMRATE SMB
if [[ $(grep microsoft-ds $DIRECTORY/tcp.nmap | grep open | cut -d" " -f1 | cut -d"/" -f1) ]];then
	echo "SMB FOUND"
	gnome-terminal --window-with-profile=Matrix  -e "./smb_enum.sh $1"
fi

# ENUMRATE FTP
if [[ $(grep ftp $DIRECTORY/tcp.nmap | grep open | cut -d" " -f1 | cut -d"/" -f1) ]];then
	echo "FTP FOUND"
	gnome-terminal --window-with-profile=Matrix  -e "./ftp_enum.sh $1"
fi

# ENUMRATE MS-SQL
if [[ $(grep ms-sql $DIRECTORY/tcp.nmap | grep open | cut -d" " -f1 | cut -d"/" -f1) ]];then
	echo "MS-SQL FOUND"
	gnome-terminal --window-with-profile=Matrix  -e "./ms-sql_enum.sh $1"
fi

# ENUMRATE SMTP
if [[ $(grep smtp $DIRECTORY/tcp.nmap | grep open | cut -d" " -f1 | cut -d"/" -f1) ]];then
	echo "SMTP FOUND"
	gnome-terminal --window-with-profile=Matrix  -e "./smtp_enum.sh $1"
fi

# ENUMRATE SNMP
if [[ $(grep snmp $DIRECTORY/udp.nmap | grep open | cut -d" " -f1 | cut -d"/" -f1) ]];then
	echo "SNMP FOUND"
	gnome-terminal --window-with-profile=Matrix  -e "./snmp_enum.sh $1"
fi

# ENUMRATE MYSQL
if [[ $(grep mysql $DIRECTORY/tcp.nmap | grep open | cut -d" " -f1 | cut -d"/" -f1) ]];then
	echo "MYSQL FOUND"
	gnome-terminal --window-with-profile=Matrix  -e "./mysql_enum.sh $1"
fi
echo DONE
read 
