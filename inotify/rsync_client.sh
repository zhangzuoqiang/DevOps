#rsync client  master
#rsync client + inotify 192.168.16.230	master m1
yum install rsync -y
mkdir /etc/rsync
echo "redhat">/etc/rsync/rsync.secrets
chmod 600 /etc/rsync/rsync.secrets
cat /etc/rsync/rsync.secrets
mkdir /data/{web,web_data}/redhat.sx -p
touch /data/{web/redhat.sx/index.html,web_data/redhat.sx/a.jpg}

rsync -avzP /data/web/redhat.sx rsync_ckj@192.168.16.207::web/ --password-file=/etc/rsync/rsync.secrets
rsync -avzP /data/web_data/redhat.sx  rsync_ckj@192.168.16.207::data/ --password-file=/etc/rsync/rsync.secrets

rsync服务器上提供了哪些可用的数据源
# rsync  --list-only  root@192.168.16.207::