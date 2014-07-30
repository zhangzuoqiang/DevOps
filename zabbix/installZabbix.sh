#下载zabbix
tar zxvf zabbix-2.2.5.tar.gz 


groupadd zabbix
useradd -g zabbix zabbix

yum install -y gcc curl curl-devel net-snmp net-snmp-devel perl-DBI php-bcmath  php-mbstring
yum install -y mysql-server mysql mysql-server mysql-devel
yum install -y httpd  php php-mysql php-common php-mbstring php-gd php-odbc php-xml php-pear
#启动mysql
service mysqld start
#初始化mysql zabbix 数据库
mysql -uroot -p
mysql> create database zabbix character set utf8 collate utf8_bin;
mysql> grant all privileges on zabbix.* to zabbix@localhost identified by 'zabbix';
mysql> exit

#Import initial schema and data.
mysql -u<username> -p<password> zabbix < database/mysql/schema.sql
# stop here if you are creating database for Zabbix proxy
mysql -u<username> -p<password> zabbix < database/mysql/images.sql
mysql -u<username> -p<password> zabbix < database/mysql/data.sql


./configure --prefix=/usr/local/zabbix --enable-server --enable-agent --with-mysql --enable-ipv6 \
 --with-net-snmp --with-libcurl --with-libxml2

configure: error: Not found mysqlclient library
解决：# ln -s /usr/lib64/mysql/libmysqlclient.so.16 /usr/lib64/mysql/libmysqlclient.so
 
Configure: error: xml2-config not found. Please check your libxml2 installation.
解决：#yum install libxml2 libxml2-devel

To configure the sources for a Zabbix proxy (with SQLite etc.)
./configure --prefix=/usr --enable-proxy --with-net-snmp --with-sqlite3 --with-ssh2

To configure the sources for a Zabbix agent, you may run:
./configure --enable-agent

make install

#修改响应的配置文件
 /usr/local/etc/zabbix_agentd.conf
 /usr/local/etc/zabbix_server.conf
 /usr/local/etc/zabbix_proxy.conf


 mkdir /var/www/html/zabbix
 cd frontends/php
cp -a . /var/www/html/zabbix

cd zabbix-2.0.6
#server
cp misc/init.d/fedora/core5/zabbix_server /etc/init.d/
#agent
cp misc/init.d/fedora/core5/zabbix_agentd /etc/init.d/
chown -R zabbix:zabbix /usr/local/zabbix
vi /etc/init.d/zabbix_server

#修改开机自启动
chkconfig --add zabbix_server
chkconfig --level 35 zabbix_server on


servier httpd restart

vi /etc/php.ini

rpm -ivh http://ftp.sjtu.edu.cn/fedora/epel/6/x86_64/epel-release-6-8.noarch.rpm
yum -y install php-mbstring 
然后编辑你的php.ini文件添加 
 extension=mbstring.so 
最后重启httpd服务 
 service httpd restart 
