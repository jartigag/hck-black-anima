#!/bin/bash
#
# usage: openvpn.sh user@ipVPNRouter

# gen
openvpn --genkey --secret server.key
# config
ipLocal=192.168.1.100
ipRemota=192.168.1.101
echo -e "dev tun \nifconfig $ipLocal $ipRemota \nsecret server.key" > server.conf
echo -e "remote $2 \ndev tun\nifconfig $ipRemota $ipLocal \nsecret server.key" > client.conf
# copy & init
cp secret.key /etc/openvpn
cp client.conf /etc/openvpn
scp secret.key $1@$2:/etc/openvpn/ server.conf $1@$2:/etc/openvpn/
ssh $1@$2 service openvpn start
sudo service openvpn start
rm secret.key client.conf server.conf