#!/bin/bash  
#/usr/local/sbin/realserver
SNS_VIP=192.168.32.150  
/etc/rc.d/init.d/functions  
case "$1" in  
start)  
       ifconfig lo:0 $SNS_VIP netmask 255.255.255.255 broadcast $SNS_VIP  
       /sbin/route add -host $SNS_VIP dev lo:0  
       echo "1" >/proc/sys/net/ipv4/conf/lo/arp_ignore  
       echo "2" >/proc/sys/net/ipv4/conf/lo/arp_announce  
       echo "1" >/proc/sys/net/ipv4/conf/all/arp_ignore  
       echo "2" >/proc/sys/net/ipv4/conf/all/arp_announce  
       sysctl -p >/dev/null 2>&1  
       echo "RealServer Start OK"   
       ;;  
stop)  
       ifconfig lo:0 down  
       route del $SNS_VIP >/dev/null 2>&1  
       echo "0" >/proc/sys/net/ipv4/conf/lo/arp_ignore  
       echo "0" >/proc/sys/net/ipv4/conf/lo/arp_announce  
       echo "0" >/proc/sys/net/ipv4/conf/all/arp_ignore  
       echo "0" >/proc/sys/net/ipv4/conf/all/arp_announce  
       echo "RealServer Stoped"  
       ;;  
status)
       # Status of LVS-DR real server.
        islothere=`/sbin/ifconfig lo:0 |grep $SNS_VIP`
        isrothere=`netstat -rn | grep "lo:0" | grep $SNS_VIP`
        if [ ! "$islothere" -o ! "isrothere" ];then
            # Either the route or the lo:0 device
            # not found.
            echo "LVS-DR real server Stopped."
        else
            echo "LVS-DR Running."
        fi
        ;;
*)  
       echo "Usage: $0 {start|stop|status}"  
       exit 1  
esac  
exit 0 