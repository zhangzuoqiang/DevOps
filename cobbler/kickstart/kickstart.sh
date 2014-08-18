#!/bin/sh

#  kicstart.sh
#  
#
#  Created by chen kejun on 14-6-24.
#

mkdir /media/cdrom
mount -o loop /dev/cdrom /media/cdrom

cat > /etc/yum.repos.d/local_repo.repo <<EOF
[Server]
name=rhel6server
baseurl=file:///media/cdrom/Server

enable=1
gpcheck=1
gpgkey=file:///media/cdrom/RPM-GPG-KEY-redhat-release
EOF


yum -y install dhcp
yum -y install tftp-server xinetd
yum -y install syslinux
yum -y install httpd
yum -y install cobbler

chkconfig dhcpd on
chkconfig tftp on
chkconfig xinetd on
chkconfig httpd on
service xinetd start
service cobblerd start

##关闭SELIINUX
sed -i 's/SELINUX=enforcing/SELINUX=disabled/g' /etc/selinux/config
sed -i 's/SELINUX=permissive/SELINUX=disabled/g' /etc/selinux/config
setenforce 0

#
sed -i 's:/var/www/html:/media:g' /etc/httpd/conf/httpd.conf
service httpd restart
cp /usr/share/doc/dhcp-4.1.1/dhcpd.conf.sample  /etc/dhcp/dhcpd.conf

cat > /etc/dhcp/dhcpd.conf <<EOF
# dhcpd.conf
default-lease-time 600;
max-lease-time 7200;

# Use this to send dhcp log messages to a different log file (you also
# have to hack syslog.conf to complete the redirection).
log-facility local7;

#至少一个subnet
subnet 192.168.20.0 netmask 255.255.255.0 {
range 192.168.20.200 192.168.20.230;
#option domain-name-servers ns1.internal.example.org;
#option domain-name "internal.example.org";
option routers 192.168.20.230;
option broadcast-address 192.168.20.255;
default-lease-time 600;
max-lease-time 7200;
next-server 192.168.20.230; #可以是dns服务器，也可以是tftp
filename "pxelinux.0";#使用引导
}
EOF


service dhcpd restart

#限制dhcp监听网卡
sed -i 's/DHCPDARGS=/DHCPDARGS=eth0/g' /etc/sysconfig/dhcpd

sed -i 's/disable=yes/disable=no/g' /etc/xinetd.d/tftp

service xinetd restart

cp /usr/share/syslinux/pxelinux.0 /var/lib/tftpboot/
mkdir /var/lib/tftpboot/pxelinux.cfg
cp /media/cdrom/isolinux/isolinux.cfg /var/lib/tftpboot/pxelinux.cfg/default
cp /media/cdrom/images/pxeboot/initrd.img /var/lib/tftpboot/
cp /media/cdrom/images/pxeboot/vmlinuz /var/lib/tftpboot/


cat > /var/lib/tftpboot/pxelinux.cfg/default <<EOF
default linux
prompt 1
timeout 600

label linux
menu label ^Install or upgrade an existing system
menu default
kernel vmlinuz
append initrd=initrd.img ks=http://192.168.16.320/ks.cfg ksdevice=em1
EOF

#多网卡安装，提示需要选择网卡 加上ksdevice=em1指定

#cp ks.cfg /media/
