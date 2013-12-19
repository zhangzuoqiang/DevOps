#!/bin/bash
mkdir /mnt/cdrom
mount -t auto /dev/cdrom /media/cdrom

cat >> /etc/yum.repos.d/local_repo.repo <<EOF


[Server]
name=rhel6server
baseurl=file:///media/cdrom/Server
 
enable=1
gpcheck=1
gpgkey=file:///media/cdrom/RPM-GPG-KEY-redhat-release

EOF

