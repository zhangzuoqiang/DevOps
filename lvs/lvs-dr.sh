#!/bin/bash  
#/usr/local/sbin/lvs-dr.sh 
#website director vip.
GW=192.168.32.1

SNS_VIP=192.168.32.150 
SNS_RIP1=192.168.32.149  
SNS_RIP2=192.168.32.151 
/etc/rc.d/init.d/functions  
logger $0 called with $1  
case "$1" in  
start)  
     # set vip  
     /sbin/ipvsadm --set 30 5 60  
     /sbin/ifconfig eth0:0 $SNS_VIP broadcast $SNS_VIP netmask 255.255.255.255 broadcast $SNS_VIP up  
     /sbin/route add -host $SNS_VIP dev eth0:0  
     /sbin/ipvsadm -A -t $SNS_VIP:80 -s wrr -p 3  
     /sbin/ipvsadm -a -t $SNS_VIP:80 -r $SNS_RIP1:80 -g -w 1  
     /sbin/ipvsadm -a -t $SNS_VIP:80 -r $SNS_RIP2:80 -g -w 1  
     touch /var/lock/subsys/ipvsadm >/dev/null 2>&1  

     #set arp
     /sbin/arping -I eth0 -c 5 -s $SNS_VIP $GW >/dev/null 2>&1 
    ;;  
stop)  
     /sbin/ipvsadm -C  
     /sbin/ipvsadm -Z  
     ifconfig eth0:0 down  
     route del $SNS_VIP  
     rm -rf /var/lock/subsys/ipvsadm >/dev/null 2>&1  
     /sbin/arping -I eth0 -c 5 -s $SNS_VIP $GW
     echo "ipvsadm stoped"  
    ;;  
status)  
     if [ ! -e /var/lock/subsys/ipvsadm ];then  
             echo "ipvsadm stoped"  
             exit 1  
     else  
            ipvsadm -l
             echo "ipvsadm OK"  
     fi  
   ;;  
*)  
         echo "Usage: $0 {start|stop|status}"  
         exit 1  
esac  
exit 0 