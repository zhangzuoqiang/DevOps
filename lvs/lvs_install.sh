#lvs install
master:192.168.32.147
slave:192.168.32.148
vip:192.168.32.150
rs1:192.168.32.149
rs2:192.168.32.151

#检查内核是否支持ipvs
modprobe -l |grep ipvs
yum -y install kernel-devel gcc openssl popt popt-devel \
libnl libnl-devel popt-static openssl openssl-devel

ln -s /usr/src/kernels/2.6.32-431.20.5.el6.x86_64 /usr/src/linux

wget http://www.linuxvirtualserver.org/software/kernel-2.6/ipvsadm-1.26.tar.gz
tar zxvf ipvsadm-1.26.tar.gz
cd ipvsadm-1.26
make && make install
ipvsadm --help 


yum install keepalived

cp /usr/local/etc/rc.d/init.d/keepalived /etc/rc.d/init.d/
cp /usr/local/etc/sysconfig/keepalived /etc/sysconfig/
mkdir /etc/keepalived
cp /usr/local/etc/keepalived/keepalived.conf /etc/keepalived/
cp /usr/local/sbin/keepalived /usr/sbin/
service keepalived start|stop


GRANT ALL PRIVILEGES ON *.* TO 'root'@'%' IDENTIFIED BY '123456' WITH GRANT OPTION;

DS:
ifconfig eth0:0 192.168.32.150 broadcast 192.168.32.255 netmask 255.255.255.255 up
route add -host 192.168.32.150 dev eth0:0
echo "1" >/proc/sys/net/ipv4/ip_forward
ipvsadm -C
ipvsadm -A -t 192.168.32.150:80 -s rr -p 600
ipvsadm -a -t 192.168.32.150:80 -r 192.168.32.149:80 -g
ipvsadm -a -t 192.168.32.150:80 -r 192.168.32.151:80 -g



1. lvs-nat:
检查三台服务器防火墙
iptables -L -n
sestatus

ds: 2网卡
echo 1 > /proc/sys/net/ipv4/ip_forward
ifconfig eth0 192.168.32.147 netmask 255.255.255.0
ifconfig eth1 192.168.32.150 netmask 255.255.255.0
route add default gw 192.168.32.2
route -n

cat >> lvs-nat.sh <<EOF
ipvsadm -C
ipvsadm -At 192.168.32.150:80 -s rr
ipvsadm -at 192.168.32.150:80 -r 192.168.32.149:80 -m
ipvsadm -at 192.168.32.150:80 -r 192.168.32.151:80 -m
ipvsadm
EOF
chmod +x lvs-nat.sh
./lvs-nat.sh

rs1:
ifconfig eth1 192.168.10.2 netmask 255.255.255.0
route add default gw 192.168.32.2
route -n
rs2:
ifconfig eth1 192.168.10.3 netmask 255.255.255.0
route add default gw 192.168.32.2
route -n

2. lvs-ip tun:
ifconfig eth0 200.168.10.1 netmask 255.255.255.0
ifconfig tunl0 200.168.10.10 netmask 255.255.255.255 up
route add -host 200.168.10.10 dev   tunl0

cat >> lvs-tun.sh <<EOF
ipvsadm -C
ipvsadm -At 200.168.10.10:80 -s rr
ipvsadm -at 200.168.10.10:80 -r 200.168.10.2:80 -i
ipvsadm -at 200.168.10.10:80 -r 200.168.10.3:80 -i
ipvsadm
EOF

rs1:
ifconfig eth0 200.168.10.2 netmask 255.255.255.0
ifconfig tunl0 200.168.10.10 netmask 255.255.255.255 up
route add -host 200.168.10.10 dev tunl0
echo "1" > /proc/sys/net/ipv4/conf/tunl0/arp_ignore
echo "2" > /proc/sys/net/ipv4/conf/tunl0/arp_announce
echo "1" > /proc/sys/net/ipv4/conf/all/arp_ignore
echo "2" > /proc/sys/net/ipv4/conf/all/arp_announce


rs2:
ifconfig eth0 200.168.10.3 netmask 255.255.255.0
ifconfig tunl0 200.168.10.10 netmask 255.255.255.255 up
route add -host 200.168.10.10 dev tunl0
echo "1" > /proc/sys/net/ipv4/conf/tunl0/arp_ignore
echo "2" > /proc/sys/net/ipv4/conf/tunl0/arp_announce
echo "1" > /proc/sys/net/ipv4/conf/all/arp_ignore
echo "2" > /proc/sys/net/ipv4/conf/all/arp_announce

2. lvs-dr tun:
ifconfig eth0:0 200.168.10.10 netmask 255.255.255.255
route add -host 200.168.10.10 dev eht0:0
ifconfig tunl0 down

cat >> lvs-dr.sh <<EOF
ipvsadm -C
ipvsadm -At 200.168.10.10:80 -s rr
ipvsadm -at 200.168.10.10:80 -r 200.168.10.2:80 -g
ipvsadm -at 200.168.10.10:80 -r 200.168.10.3:80 -g
ipvsadm
EOF


rs1:
ifconfig eth0 200.168.10.2 netmask 255.255.255.0
ifconfig lo:0 200.168.10.10 netmask 255.255.255.255 up
route add -host 200.168.10.10 dev lo:0
echo "1" > /proc/sys/net/ipv4/conf/lo/arp_ignore
echo "2" > /proc/sys/net/ipv4/conf/lo/arp_announce
echo "1" > /proc/sys/net/ipv4/conf/all/arp_ignore
echo "2" > /proc/sys/net/ipv4/conf/all/arp_announce
ifconfig tunl0 down

rs2:
ifconfig eth0 200.168.10.3 netmask 255.255.255.0
ifconfig lo:0 200.168.10.10 netmask 255.255.255.255 up
route add -host 200.168.10.10 dev lo:0
echo "1" > /proc/sys/net/ipv4/conf/lo/arp_ignore
echo "2" > /proc/sys/net/ipv4/conf/lo/arp_announce
echo "1" > /proc/sys/net/ipv4/conf/all/arp_ignore
echo "2" > /proc/sys/net/ipv4/conf/all/arp_announce
ifconfig tunl0 down

