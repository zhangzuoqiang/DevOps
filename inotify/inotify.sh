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
src1='/data/web/redhat.sx/'

des1=web
des2=data
host1=192.168.16.206
host2=172.16.100.1
user=rsync_ckj
allrsync='/usr/bin/rsync -rpgovz --delete --progress'
/usr/local/bin/inotifywait -mrq --timefmt '%d/%m/%y %H:%M' --format '%T %w %w%f %e' -e modify,delete,create,attrib /data/web/redhat.sx/ | while read DATE TIME DIR FILE EVENT;
do
case $DIR in
${src1}*)
/usr/bin/rsync -rpgovz --delete --progress /data/web/redhat.sx/ rsync_ckj@192.168.16.206::web --password-file=/etc/rsync.password && echo "$DATE $TIME $FILE was rsynced" &>> /var/log/rsync-$des1-$host1.log
/usr/bin/rsync -rpgovz --delete --progress $src1 $user@$host2::$des1 --password-file=/etc/rsync.password && echo "$DATE $TIME $FILE was rsynced" &>> /var/log/rsync-$des1-$host2.log
;;
${src2}*)
$allrsync  $src2 $user@192.168.16.206::$des2 --password-file=/etc/rsync.password && echo "$DATE $TIME $FILE was rsynced" &>> /var/log/rsync-$des2-$host1.log
$allrsync  $src2 $user@$host2::$des2 --password-file=/etc/rsync.password && echo "$DATE $TIME $FILE was rsynced" &>> /var/log/rsync-$des2-$host2.log
;;
esac
done


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

