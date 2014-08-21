#rsync server1			192.168.16.206  slave1 s1
#rsync server2			192.168.16.207	slave2 s2
yum install rsync -y
mkdir /etc/rsyncd
cat > /etc/rsyncd/rsyncd.conf << EOF
#Rsync server
#created by chenkj
##rsyncd.conf start##
port = 873
address = 192.168.16.206
uid = root
gid = root
use chroot = no
max connections = 2000
timeout = 600
pid file = /var/run/rsyncd.pid
lock file = /var/run/rsync.lock
log file = /var/log/rsyncd.log
ignore errors
read only = false
list = false
hosts allow = 192.168.16.0/24
hosts deny = *
auth users = rsync_ckj
secrets file = /etc/rsyncd/rsyncd.secrets
#####################################
[web]
comment = redhat.sx site files 
path = /data/web/redhat.sx
secrets file=/etc/rsyncd/rsyncd.secrets
read only = false
####################################
[data]
comment = redhat.sx site sit data files
path = /data/web_data/redhat.sx
secrets file=/etc/rsyncd/rsyncd.secrets
read only = false
#####################################
EOF

mkdir /data/{web,web_data}/redhat.sx -p
tree /data

echo 'rsync_ckj:redhat' > /etc/rsyncd/rsyncd.secrets
chmod 600 /etc/rsyncd/rsyncd.secrets
cat /etc/rsyncd/rsyncd.secrets
rsync --daemon --config=/etc/rsyncd/rsyncd.conf

lsof -i tcp:873
#echo "/usr/bin/rsync --daemon --config=/etc/rsyncd/rsyncd.conf"  >> /etc/rc.local

# pkill rsync
# rsync --daemon