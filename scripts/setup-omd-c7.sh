#!/bin/bash
yum update -y
yum install -y epel-release wget
wget https://mathias-kettner.de/support/1.2.8p21/check-mk-raw-1.2.8p21-el7-44.x86_64.rpm
yum install -y check-mk-raw-1.2.*
omd create site1
omd start site1

## Open port 80 for httpd
check_fw=`rpm -qa | grep firewalld`
setenforce 0
sed -i 's/SELINUX=enforcing/SELINUX=disabled/g' /etc/selinux/config
if [ -n "$check_fw" ]
then
  firewall-cmd --add-port=80/tcp --permanent
  firewall-cmd --reload
fi 