#!/bin/sh

#  cobbler.sh
#  
#
#  Created by chen kejun on 14-6-25.
# http://mirrors.ustc.edu.cn/fedora/epel/6/x86_64/
#

#关闭selinux

rpm -Uvh 'http://mirrors.ustc.edu.cn/fedora/epel/6/x86_64/epel-release-6-8.noarch.rpm'
yum -y install cobbler tftp-server rsync xinetd httpd


#启动cobblerd服务
service cobblerd start
#启动httpd服务
service httpd start


sed -i 's/next_server: 127.0.0.1/next_server: 192.168.32.134/g' /etc/cobbler/settings
sed -i 's/server: 127.0.0.1/server: 192.168.32.134/g' /etc/cobbler/settings
sed -i 's/disable = yes/disable = no/g' /etc/xinetd.d/tftp
sed -i 's/yes/no/g' /etc/xinetd.d/rsync

# 检查配置
cobbler check

cobbler get-loaders
yum -y install debmirror pykickstart fence-agents
sed -i 's/@dists="sid"/#@dists="sid"/g' /etc/debmirror.conf
sed -i 's/@arches="i386"/#@arches="i386"/g' /etc/debmirror.conf

#openssl passwd -1 -salt 'random-phrase-here' 'your-password-here'
#openssl passwd -1 -salt 'winupon' 'winupon'
# $1$winupon$2gSwlvXffbk0CRc9IL5Jx0
#sed -i 's/$1$mF86/UHC$WvcIcX2t6crBz2onWxyac./$1$winupon$2gSwlvXffbk0CRc9IL5Jx0/g' /etc/cobbler/settings

service  cobblerd restart
cobbler sync

mount -o loop /dev/cdrom /media/cdrom
cobbler import --path=/media/cdrom --name=rhel-6.3-x86_64


#配置dhcp
sed -i 's/manage_dhcp: 0/manage_dhcp: 1/g'  /etc/cobbler/settings
#修改 /etc/cobbler/dhcp.template

