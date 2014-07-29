#下载zabbix
tar zxvf zabbix-2.2.5.tar.gz 


groupadd zabbix
useradd -g zabbix zabbix

yum install gcc mysql-server 
yum install -y httpd mysql mysql-server mysql-devel \
php php-mysql php-common php-mbstring php-gd php-odbc php-xml php-pear
yum install -y curl curl-devel net-snmp net-snmp-devel perl-DBI php-bcmath  php-mbstring
service mysqld start


mysql -uroot
mysql> create database zabbix character set utf8 collate utf8_bin;
mysql> grant all privileges on zabbix.* to zabbix@localhost identified by 'zabbix';
mysql> exit

Import initial schema and data.

# cd /usr/share/doc/zabbix-server-mysql-2.2.0/create

shell> mysql -u<username> -p<password> zabbix < database/mysql/schema.sql
# stop here if you are creating database for Zabbix proxy
shell> mysql -u<username> -p<password> zabbix < database/mysql/images.sql
shell> mysql -u<username> -p<password> zabbix < database/mysql/data.sql


./configure --enable-server --enable-agent --with-mysql --enable-ipv6 \
 --with-net-snmp --with-libcurl --with-libxml2

  configure: error: Not found mysqlclient library
解决：# ln -s /usr/lib64/mysql/libmysqlclient.so.16 /usr/lib64/mysql/libmysqlclient.so
 
 Configure: error: xml2-config not found. Please check your libxml2 installation.
Quote:
#yum install libxml2 libxml2-devel

 To configure the sources for a Zabbix proxy (with SQLite etc.), you may run:

./configure --prefix=/usr --enable-proxy --with-net-snmp --with-sqlite3 --with-ssh2
To configure the sources for a Zabbix agent, you may run:

./configure --enable-agent

make install

 /usr/local/etc/zabbix_agentd.conf
 /usr/local/etc/zabbix_server.conf
 /usr/local/etc/zabbix_proxy.conf


 mkdir /var/www/html/zabbix
 cd frontends/php
cp -a . /var/www/html/zabbix


servier httpd restart

vi /etc/php.ini

rpm -ivh http://ftp.sjtu.edu.cn/fedora/epel/6/x86_64/epel-release-6-8.noarch.rpm
yum -y install php-mbstring 
然后编辑你的php.ini文件添加 
 extension=mbstring.so 
最后重启httpd服务 
 service httpd restart 
