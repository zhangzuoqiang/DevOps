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