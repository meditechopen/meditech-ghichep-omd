#!/bin/bash


## Cai dat Agent-OMD

## OS: RHEL 7

###############################################

echo "Nhap dia chi IP OMD Server"

read ip

echo "Nhap ten site monitoring"

read site

sleep 5

yum install wget -y 

echo "Tai goi agent Check_MK"

wget https://$ip/$site/check_mk/agents/check-mk-agent-1.2.8p20-1.noarch.rpm --no-check-certificate

## Kiem tra Xinetd

a=`rpm -qa | grep xinetd | awk 'FNR == 1 {print}'`


if [ "$a" = "xinetd-2.3.15-13.el7.x86_64" ];then
echo "Da cai dat xinetd"
else 
echo "Chua cai dat xinetd"
fi

echo "Cai dat xinetd"

yum install xinetd -y 

## Khoi dong Xinetd

systemctl start xinetd
systemctl enable xinetd

## Cai dat Agent-OMD

rpm -ivh check-mk-agent-*

## Cau hinh Agent-OMD

echo "Backup file cau hinh"

cp /etc/xinetd.d/check_mk /etc/xinetd.d/check_mk.bka

sed -i "s/127.0.0.1/$ip/g" /etc/xinetd.d/check_mk

## Khoi dong lai Xinetd

systemctl restart xinetd

## Mo port firewall

firewall-cmd --add-port=6556/tcp --permanent
firewall-cmd --reload

## Tat selinux

sed -i 's/SELINUX=enforcing/SELINUX=disabled/g' /etc/selinux/config





