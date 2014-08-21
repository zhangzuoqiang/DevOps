#inotify master
#rsync client + inotify 192.168.16.230	master m1

ll /proc/sys/fs/inotify/*

yum install make  gcc gcc-c++ -y
wget http://nchc.dl.sourceforge.net/project/inotify-tools/inotify-tools/3.13/inotify-tools-3.13.tar.gz
tar xzf inotify-tools-3.13.tar.gz
cd inotify-tools-3.13
./configure
make && make install

ll /usr/local/bin/inotify*


cat /usr/sbin/auto_rsync.sh
#!/bin/bash
#file name :/usr/sbin/auto_rsync.sh
host1=192.168.16.206
host2=192.168.16.207
src=/data/web/redhat.sx/
dst=web
user=rsync_ckj
allrsync='/usr/bin/rsync -rpgovz --delete --progress'
password='--password-file=/etc/rsync/rsync.secrets'
/usr/local/bin/inotifywait -mrq --timefmt '%d/%m/%y %H:%M' --format '%T %w%f%e' \
-e modify,delete,create,attrib  $src \
| while read files
        do
        $allrsync $password $src $user@$host1::$dst
  		$allrsync $password $src $user@$host2::$dst

                echo " ${files} was rsynced" >>/tmp/rsync.log 2>&1
        done


chmod o+x /usr/sbin/auto_rsync.sh

cat > /etc/rc.local << EOF
/usr/sbin/auto_rsync.sh & >> /var/log/auto_rsync.log &

EOF

