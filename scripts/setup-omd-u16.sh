#!/bin/bash
apt-get update
apt-get install wget gdebi-core -y
wget https://mathias-kettner.de/support/1.2.8p21/check-mk-raw-1.2.8p21_0.xenial_amd64.deb
echo y | gdebi check-mk-raw-1.2.8p21_0.xenial_amd64.deb
omd create site1
omd start site1
check_fw=`ufw status | grep -w "active"`

if [ -n "$check_fw" ]
then
    ufw allow 80/tcp
    ufw reload
    echo "Firewall has been configured."
fi 