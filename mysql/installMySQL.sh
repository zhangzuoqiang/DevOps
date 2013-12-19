#!/bin/sh

#  installMySQL.sh
#  
#
#  Created by chen kejun on 13-12-16.
#


MYSQL_VERSION=5.6.15

# 关闭Linux防火墙命令
chkconfig iptables off

##关闭SELIINUX
sed -i 's/SELINUX=enforcing/SELINUX=disabled/g' /etc/selinux/config
sed -i 's/SELINUX=permissive/SELINUX=disabled/g' /etc/selinux/config
setenforce 0

yum -y install wget gcc-c++ cmake make bison ncurses-devel perl unzip

#添加mysql 系统用户
groupadd mysql
useradd -r -g mysql mysql

mkdir -p /data/logs/mysql
mkdir -p /data/mysql

cd /usr/local/src
wget ftp://publish:my.zdsoft.deploy@deploy.winupon.com//softwares/database/mysql/mysql-$MYSQL_VERSION.tar.gz
tar zxvf mysql-$MYSQL_VERSION.tar.gz

cd mysql-$MYSQL_VERSION

cmake \
-DCMAKE_INSTALL_PREFIX=/usr/local/server/mysql-$MYSQL_VERSION \
-DMYSQL_DATADIR=/data/mysql \
-DMYSQL_UNIX_ADDR=/tmp/mysql.sock \
-DMYSQL_USER=mysql \
-DDEFAULT_CHARSET=utf8 \
-DEFAULT_COLLATION=utf8_general_ci \
-DWITH_INNOBASE_STORAGE_ENGINE=1 \
#-DENABLE_DOWNLOADS=1

make && make install

ln -s /usr/local/server/mysql-$MYSQL_VERSION /usr/local/server/mysql

chown -R mysql:mysql /usr/local/server/mysql
chown -R mysql:mysql /usr/local/server/mysql-$MYSQL_VERSION
chown -R mysql:mysql /data/mysql
chown -R mysql:mysql /data/logs/mysql


/usr/local/server/mysql/scripts/mysql_install_db --user=mysql --datadir=/data/mysql --basedir=/usr/local/server/mysql --collation-server=utf8_general_ci

cp /usr/local/server/mysql/support-files/mysql.server /etc/init.d/mysql
chkconfig mysql on

#my.cnf

cat >> /etc/my.cnf <<EOF


[mysqld]
datadir = /data/mysql
socket = /tmp/mysql.sock
pid-file = /data/logs/mysql/mysql.pid
user = mysql
port = 3306
default_storage_engine = InnoDB
# InnoDB
#innodb_buffer_pool_size = 128M
#innodb_log_file_size = 48M
innodb_file_per_table = 1
innodb_flush_method = O_DIRECT
log-bin=mysql-bin
# MyISAM
#key_buffer_size = 48M
# character-set
character-set-server=utf8
collation-server=utf8_general_ci
# name-resolve
skip-host-cache
skip-name-resolve
# LOG
log_error = /data/logs/mysql/mysql-error.log
long_query_time = 1
slow-query-log
slow_query_log_file = /data/logs/mysql/mysql-slow.log
# Others
explicit_defaults_for_timestamp=true
#max_connections = 500
open_files_limit = 65535
sql_mode=NO_ENGINE_SUBSTITUTION,STRICT_TRANS_TABLES
[client]
socket = /tmp/mysql.sock
port = 3306

endif
EOF

echo 'export PATH=$PATH:/usr/local/server/mysql/bin'>> /etc/profile



