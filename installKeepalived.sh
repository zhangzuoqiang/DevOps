#!/bin/sh

#  installKeepalived.sh
#  
#
#  Created by chen kejun on 13-12-19.
#


KEEPALIVED_VERSION=5.6.15


yum -y install openssl-devel nmap
cd /usr/local/src
wget http://www.keepalived.org/software/keepalived-$KEEPALIVED_VERSION.tar.gz
tar xzf keepalived-$KEEPALIVED_VERSION.tar.gz
cd keepalived-$KEEPALIVED_VERSION
./configure
make && make install
cp /usr/local/etc/rc.d/init.d/keepalived /etc/init.d/
cp /usr/local/etc/sysconfig/keepalived /etc/sysconfig/
chmod +x /etc/init.d/keepalived
chkconfig --add keepalived
chkconfig keepalived on
mkdir /etc/keepalived
mkdir /scripts
ln -s /usr/local/sbin/keepalived /usr/sbin/


cat >> /etc/keepalived/keepalived.conf << EOF

global_defs {
    notification_email {
        hzchenkj@gmail.com
    }

    notification_email_from keepalived@domain.com
    smtp_server 127.0.0.1
    smtp_connect_timeout 30
    router_id LVS_DEVEL
}

vrrp_script chk_http_port {
    script "/scripts/chk_nginx.sh"
    interval 2
    weight 2
}

vrrp_instance VI_1 {
    state MASTER    ###BACKUP
    interface eth0
    virtual_router_id 51
    mcast_src_ip 192.168.16.245  ###主备ip地址
    priority 101              ### master high --backup lower。。
    advert_int 1
    authentication {
        auth_type PASS
        auth_pass 1111
    }

    track_script {
        chk_http_port
    }

    virtual_ipaddress {
        192.168.16.247  #vip
    }
}


EOF

cat >> /scripts/chk_nginx.sh << EOF

#!/bin/sh
# check nginx server status
NGINX=/usr/local/nginx/sbin/nginx
PORT=80
nmap localhost -p $PORT | grep "$PORT/tcp open"
#echo $?
if [ $? -ne 0 ];then
    $NGINX -s stop
    $NGINX
    sleep 3
    nmap localhost -p $PORT | grep "$PORT/tcp open"
    [ $? -ne 0 ] && /etc/init.d/keepalived stop
fi

EOF