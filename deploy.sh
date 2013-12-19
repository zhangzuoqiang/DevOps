#!/bin/bash
FTP_USERNAME=down
FTP_PASSWORD=zdsoft.net.123
FTP_ADDR=ftp://$FTP_USERNAME:$FTP_PASSWORD@deploy.winupon.com

INSTALL_HOME=/usr/local/src

init_oracle_env()
{

##根据需要修改以下变量
export ORACLE_APP=/u01/app/oracle
export ORACLE_DATA=/u02/oradata
ORACLE_PW="zdsoft@net@123"
export ORACLE_HOME=$ORACLE_APP/product/10.2.0/db_1

##安装依赖的包


for PACKAGE in lftp binutils compat-gcc-* compat-gcc-*-c++ compat-libstdc++-*  \
    control-center gcc gcc-c++ glibc glibc-common libstdc++ libstdc++-devel  \
    make pdksh openmotif setarch sysstat glibc-devel libgcc libaio compat-db \
    libXtst libXp libXp.i686 libXt.i686 libXtst.i686  ;
do
    yum -y install $PACKAGE
done

##创建 Oracle 组和用户帐户
groupadd -g 505 oinstall
groupadd -g 506 dba
useradd -u 505 -m -g oinstall -G dba oracle
id oracle

##设置 oracle 帐户的口令

echo $ORACLE_PW |passwd oracle --stdin

##backup files
rm -fr /etc/oraInst.loc
rm -fr /etc/oratab
cp /etc/sysctl.conf /etc/sysctl.conf.oracle
cp /etc/security/limits.conf /etc/security/limits.conf.oracle
cp /etc/pam.d/login /etc/pam.d/login.oracle
cp /etc/profile /etc/profile.oracle
cp /etc/csh.login /etc/csh.login.oracle
cp /etc/selinux/config /etc/selinux/config.oracle
cp /home/oracle/.bash_profile /home/oracle/.bash_profile.oracle
cp /etc/redhat-release /etc/redhat-release.oracle



##创建目录
mkdir -p $ORACLE_APP
mkdir -p $ORACLE_DATA
chown -R oracle:oinstall $ORACLE_APP $ORACLE_DATA
chmod -R 775 $ORACLE_APP $ORACLE_DATA

##配置 Linux 内核参数
cat >> /etc/sysctl.conf <<EOF
#use for oracle
kernel.shmall = 2097152
kernel.shmmax = 20147483648
kernel.shmmni = 4096
kernel.sem = 250 32000 100 128
#fs.file-max = 65536
net.ipv4.ip_local_port_range = 9000 65500
net.core.rmem_default=1048576
net.core.rmem_max=1048576
net.core.wmem_default=262144
net.core.wmem_max=262144
EOF

/sbin/sysctl -p

##为 oracle 用户设置 Shell 限制
cat >> /etc/security/limits.conf <<EOF
#use for oracle
oracle soft nproc 2047
oracle hard nproc 16384
oracle soft nofile 4096
oracle hard nofile 65536
EOF

cat >> /etc/pam.d/login <<EOF
#session required /lib64/security/pam_limits.so
EOF

cat >> /etc/profile <<EOF
if [ \$USER = "oracle" ]; then
    if [ \$SHELL = "/bin/ksh" ]; then
        ulimit -p 16384
        ulimit -n 65536
    else
        ulimit -u 16384 -n 65536
    fi
    umask 022
fi
EOF


cat >> /etc/csh.login <<EOF
if ( \$USER == "oracle" ) then
    limit maxproc 16384
    limit descriptors 65536
    umask 022
endif
EOF

##关闭SELIINUX
sed -i 's/SELINUX=enforcing/SELINUX=disabled/g' /etc/selinux/config
sed -i 's/SELINUX=permissive/SELINUX=disabled/g' /etc/selinux/config
setenforce 0

##oracle 用户的环境变量
cat >> /home/oracle/.bash_profile <<EOF
export ORACLE_BASE=$ORACLE_APP
export ORACLE_HOME=\$ORACLE_BASE/product/10.2.0/db_1
export ORACLE_SID=center
export PATH=\$PATH:\$ORACLE_HOME/bin:\$HOME/bin
export LD_LIBRARY_PATH=\$LD_LIBRARY_PATH:\$ORACLE_HOME/lib:/usr/lib:/usr/local/lib
export NLS_LANG=AMERICAN_AMERICA.ZHS16GBK
EOF


##su - oracle -c "/home/oracle/.bash_profile"



##设置Oracle10g支持RHEL5的参数
cp /etc/redhat-release /etc/redhat-release.orig

echo "redhat-4" > /etc/redhat-release

}

download_oracle() {

    ##下载oracle
    SYSTEM=`uname -p`
    if [ "$SYSTEM" = "x86_64" ]
      then
        if [ -f 10201_database_linux_x86_64.cpio.gz ]  ; then
	        zcat 10201_database_linux_x86_64.cpio.gz |cpio -idmv	
	else
		lftp -c "pget -n 10 $FTP_ADDR/softwares/database/oracle/10201_database_linux_x86_64.cpio.gz"
		zcat 10201_database_linux_x86_64.cpio.gz |cpio -idmv
	fi
    
      else
        lftp -c "pget -n 10 $FTP_ADDR/softwares/database/oracle/10201_database_linux32.zip"       
        unzip 10201_database_linux32.zip
        sleep 1
      fi
      wget  $FTP_ADDR/scripts/oracle/initcenter.ora
}


install_ora_app() {

##执行静默安装oracle
su - oracle -c "$INSTALL_HOME/database/runInstaller -silent -responseFile $INSTALL_HOME/database/response/enterprise.rsp \
UNIX_GROUP_NAME="oinstall" ORACLE_HOME="/u01/app/oracle/product/10.2.0/db_1" \
ORACLE_HOME_NAME="OraDb10g_home1" s_nameForDBAGrp="dba" s_nameForOPERGrp="dba" n_configurationOption=3 "

rm /etc/redhat-release
cp /etc/redhat-release.orig /etc/redhat-release

echo "##########################################"
echo 'success install oracle software'

}


create_ora_db(){

su - oracle -c 'mkdir -p /u01/app/oracle/product/10.2.0/db_1/dbs'
su - oracle -c 'mkdir -p /u01/app/oracle/admin/center/adump'
su - oracle -c 'mkdir -p /u01/app/oracle/admin/center/bdump'
su - oracle -c 'mkdir -p /u01/app/oracle/admin/center/cdump'
su - oracle -c 'mkdir -p /u01/app/oracle/admin/center/dpdump'
su - oracle -c 'mkdir -p /u01/app/oracle/admin/center/pfile'
su - oracle -c 'mkdir -p /u01/app/oracle/admin/center/udump'
su - oracle -c 'mkdir -p /u02/oradata/center'
su - oracle -c 'mkdir -p /u02/oradata/center/archive'

cp $INSTALL_HOME/initcenter.ora /u01/app/oracle/product/10.2.0/db_1/dbs
cp $INSTALL_HOME/initcenter.ora /u01/app/oracle/admin/center/pfile

chown oracle:oinstall /u01/app/oracle/admin/center/pfile/initcenter.ora
chmod a+x /u01/app/oracle/admin/center/pfile/initcenter.ora

echo 'success cp file ,begin to sqlplus ...'

su - oracle -c 'sqlplus / as sysdba' << EOF
startup nomount pfile=/u01/app/oracle/admin/center/pfile/initcenter.ora
EOF
echo 'sucecess startup database in nomount state'

su - oracle -c 'sqlplus / as sysdba' << EOF
CREATE DATABASE center
LOGFILE
GROUP 1 ('/u02/oradata/center/redo01.log','/u02/oradata/center/redo01_1.log') size 500m reuse,
GROUP 2 ('/u02/oradata/center/redo02.log','/u02/oradata/center/redo02_1.log') size 500m reuse,
GROUP 3 ('/u02/oradata/center/redo03.log','/u02/oradata/center/redo03_1.log') size 500m reuse
MAXLOGFILES 50
MAXLOGMEMBERS 5
MAXLOGHISTORY 200
MAXDATAFILES 500
MAXINSTANCES 5
ARCHIVELOG
CHARACTER SET ZHS16GBK
NATIONAL CHARACTER SET AL16UTF16
DATAFILE '/u02/oradata/center/system01.dbf' SIZE 600M EXTENT MANAGEMENT LOCAL
SYSAUX DATAFILE '/u02/oradata/center/sysaux01.dbf' SIZE 500M
UNDO TABLESPACE UNDOTS DATAFILE '/u02/oradata/center/undo.dbf' SIZE 500M
DEFAULT TEMPORARY TABLESPACE TEMP TEMPFILE '/u02/oradata/center/temp.dbf' SIZE 500M;


@/u01/app/oracle/product/10.2.0/db_1/rdbms/admin/catalog.sql
@/u01/app/oracle/product/10.2.0/db_1/rdbms/admin/catproc.sql
conn system/manager
@/u01/app/oracle/product/10.2.0/db_1/sqlplus/admin/pupbld.sql
EOF


}


set_ora_autorun() {
	
export ORACLE_APP=/u01/app/oracle	
export ORACLE_BASE=/u01/app/oracle
export ORACLE_HOME=/u01/app/oracle/product/10.2.0/db_1
export ORACLE_SID=center	
	
   
echo "${ORACLE_SID}:${ORACLE_HOME}:Y" >/etc/oratab

sed -i 's/\/ade\/vikrkuma_new\/oracle/\$ORACLE_HOME/g' $ORACLE_HOME/bin/dbstart
cat > /etc/init.d/oracle <<EOF


#!/bin/bash
#chkconfig:345 61 61 //此行的345参数表示,在哪些运行级别启动,启动序号(S61);关闭序号(K61)
#description:Oracle


export ORACLE_APP=/u01/app/oracle	
export ORACLE_BASE=/u01/app/oracle
export ORACLE_HOME=/u01/app/oracle/product/10.2.0/db_1
export ORACLE_SID=center
export PATH=\$PATH:\$ORACLE_HOME/bin

ORA_OWNR="oracle"

# if the executables do not exist -- display error

if [ ! -f \$ORACLE_HOME/bin/dbstart -o ! -d \$ORACLE_HOME ]
then
echo "Oracle startup: cannot start"
exit 1
fi
# depending on parameter -- startup, shutdown, restart
# of the instance and listener or usage display

case "\$1" in
start)
# Oracle listener and instance startup
echo -n "Starting Oracle: "
su \$ORA_OWNR -c "\$ORACLE_HOME/bin/lsnrctl start"
su \$ORA_OWNR -c \$ORACLE_HOME/bin/dbstart
touch /var/lock/oracle

#su \$ORA_OWNR -c "\$ORACLE_HOME/bin/emctl start dbconsole"
echo "OK"
;;
stop)
# Oracle listener and instance shutdown
echo -n "Shutdown Oracle: "
su \$ORA_OWNR -c "\$ORACLE_HOME/bin/lsnrctl stop"
su \$ORA_OWNR -c \$ORACLE_HOME/bin/dbshut
rm -f /var/lock/oracle

#su \$ORA_OWNR -c "\$ORACLE_HOME/bin/emctl stop dbconsole"
echo "OK"
;;
reload|restart)
\$0 stop
\$0 start
;;
*)
echo "Usage: \`basename \$0\` start|stop|restart|reload"
exit 1
esac
exit 0

EOF

chmod a+x /etc/init.d/oracle

chkconfig oracle on
   

}

install_cache(){

cd $INSTALL_HOME

mkdir -p /opt
chown -R winupon:winupon /opt

if [ -f libevent-1.4.14b-stable.tar.gz ]  ; then
	        tar zxvf libevent-1.4.14b-stable.tar.gz >> $INSTALL_HOME/install.log	
else
		lftp -c "pget -n 10 $FTP_ADDR/softwares/memcache/libevent-1.4.14b-stable.tar.gz"
		tar zxvf libevent-1.4.14b-stable.tar.gz >> $INSTALL_HOME/install.log
fi

cd libevent-1.4.14b-stable 
./configure --prefix=/usr >> $INSTALL_HOME/install.log
make >> $INSTALL_HOME/install.log
make install >> $INSTALL_HOME/install.log
cd $INSTALL_HOME
rm -rf libevent-1.4.14b-stable*

echo 'install libevent succesed!'

cd $INSTALL_HOME

echo 'install the memcached server...' 
cd $INSTALL_HOME

if [ -f memcached-1.4.5.tar.gz ]  ; then
	       tar zxvf memcached-1.4.5.tar.gz >> $INSTALL_HOME/install.log
else
		lftp -c "pget -n 10 $FTP_ADDR/softwares/memcache/memcached-1.4.5.tar.gz"
		tar zxvf memcached-1.4.5.tar.gz >> $INSTALL_HOME/install.log
fi
cd memcached-1.4.5
./configure --prefix=/opt/memcached --with-libevent=/usr >> $INSTALL_HOME/install.log
make >> $INSTALL_HOME/install.log
make install >> $INSTALL_HOME/install.log
cd ..
rm -rf memcached-1.4.5*

ln -s /usr/lib/libevent-1.4.so.2 /usr/lib64/libevent-1.4.so.2

echo '========********install memcached successed!******* ======'

echo "/opt/memcached/bin/memcached -d -m 1024 -u root -p 11211" >>/etc/rc.local

}

install_jdk(){

cd $INSTALL_HOME

mkdir -p /opt
chown -R winupon:winupon /opt

if [ -f jdk1.6.0_38.tar.gz ]  ; then
		tar xvf jdk1.6.0_38.tar.gz
else
		lftp -c "pget -n 10 $FTP_ADDR/softwares/jdk/jdk1.6.0_38.tar.gz"
		tar xvf jdk1.6.0_38.tar.gz
fi

cp -r jdk1.6.0_38  /opt/

cat >> /etc/profile <<EOF

export JAVA_HOME=/opt/jdk1.6.0_38
export PATH=\$JAVA_HOME/bin:\$PATH

EOF

source /etc/profile
rm -rf $INSTALL_HOME/jdk1.6.0_38

}


install_tomcat() {

if [ -f apache-tomcat-6.0.35.tar.gz ]  ; then
	        tar zxvf apache-tomcat-6.0.35.tar.gz >> $INSTALL_HOME/install.log	
else
		lftp -c "pget -n 10 $FTP_ADDR/softwares/tomcat/apache-tomcat-6.0.35.tar.gz"
		tar zxvf apache-tomcat-6.0.35.tar.gz >> $INSTALL_HOME/install.log	
fi

cp -r apache-tomcat-6.0.35 /opt/
wget $FTP_ADDR/scripts/tomcat/tomcat
cp tomcat /etc/init.d/tomcat
chmod +x /etc/init.d/tomcat
chkconfig --add tomcat
chkconfig tomcat on

chown -R winupon:winupon /opt/apache-tomcat-6.0.35/
chmod a+x /opt/apache-tomcat-6.0.35/bin/*.sh

mkdir -p /opt/data
chown -R winupon:winupon /opt/data
rm -rf $INSTALL_HOME/apache-tomcat-6.0.35*

}

install_nginx(){
cd $INSTALL_HOME
yum -y install pcre-devel openssl-devel gcc

if [ -f nginx-0.7.61.tar.gz ]  ; then
	       tar zxvf nginx-0.7.61.tar.gz
else
		lftp -c "pget -n 10 $FTP_ADDR/softwares/nginx/nginx-0.7.61.tar.gz"
		tar zxvf nginx-0.7.61.tar.gz
fi

if [ -f nginx-upstream-jvm-route-0.1.tar.gz ]  ; then
	       tar zxvf nginx-upstream-jvm-route-0.1.tar.gz
else
		lftp -c "pget -n 10 $FTP_ADDR/softwares/nginx/nginx-upstream-jvm-route-0.1.tar.gz"
		tar zxvf nginx-upstream-jvm-route-0.1.tar.gz
fi

cd nginx-0.7.61
#patch 
patch -p0 < ../nginx_upstream_jvm_route/jvm_route.patch
#install
./configure --prefix=/usr/local/nginx --with-http_stub_status_module --with-http_gzip_static_module --add-module=$INSTALL_HOME/nginx_upstream_jvm_route/
make && make install

cd $INSTALL_HOME
#make auto start
wget $FTP_ADDR/scripts/nginx/nginx
cp $INSTALL_HOME/nginx /etc/init.d/
chmod +x /etc/init.d/nginx
chkconfig --add nginx

#cp nginx conf file
cp /usr/local/nginx/conf/nginx.conf /usr/local/nginx/conf/nginx.conf.orig
wget $FTP_ADDR/scripts/nginx/nginx.conf 
cp $INSTALL_HOME/nginx.conf /usr/local/nginx/conf/

#service nginx start
echo "Success install nginx,please modify the nginx conf file and start nginx !!!"

}


init_rhel(){

##midify nofile
cat >> /etc/security/limits.conf <<EOF
* soft nproc 2047
* hard nproc 16384
* soft nofile 40960
* hard nofile 65535
EOF

##disable ipv6
echo "alias net-pf-10 off" >> /etc/modprobe.conf
echo "alias ipv6 off" >> /etc/modprobe.conf
/sbin/chkconfig --level 35 ip6tables off
echo "ipv6 is disabled!"

##disable selinux
sed -i '/SELINUX/s/enforcing/disabled/' /etc/selinux/config

echo "Now add a common user winupon."
useradd winupon
echo "zdsoft.net.2008" |passwd winupon --stdin

##config openssh server
sed -i 's/^#Port 22/Port 65422/g' /etc/ssh/sshd_config
sed -i 's/^#PermitRootLogin yes/PermitRootLogin no/g' /etc/ssh/sshd_config
sed -i 's/^#UseDNS yes/UseDNS no/g' /etc/ssh/sshd_config

##set run level to 3
sed -i 's/^id\:5/id\:3/g' /etc/inittab
sed -i 's/^ca\:\:ctrlaltdel/#ca\:\:ctrlaltdel/g' /etc/inittab
sed -i 's/^3\:2345/#3:2345/g' /etc/inittab
sed -i 's/^4\:2345/#4:2345/g' /etc/inittab
sed -i 's/^5\:2345/#5:2345/g' /etc/inittab
sed -i 's/^6\:2345/#6:2345/g' /etc/inittab

##turnoff services
echo "Now turnoff services"

for i in `ls /etc/rc3.d/S*`
do
    CURSRV=`echo $i |cut -c 15-`
    echo $CURSRV

case $CURSRV in
        crond | irqbalance | microcode_ctl | network | random | sshd | syslog | local | readahead_early | readahead_later )
        echo "Base services, Skip"
    ;;
    *)
        echo "change $CURSRV to off"
        chkconfig --level 235 $CURSRV off
        service $CURSRV stop
    ;;
esac
done

LANG=
chkconfig --list |grep 3:on |awk  '{print "level 3 is running :   ",$1;}'

}


init_yum_repo(){
	
##setup yum repo
if [ ! -f /etc/yum.repos.d/cobbler-config.repo ] ; then
  ver=$(head -1 /etc/issue|awk '{print $7}')
  wget http://update.winupon.com/cobbler/ks_mirror/rhel-${ver}.repo  \
        -O /etc/yum.repos.d/rhel-${ver}.repo
fi

yum -y install gcc lftp

}


install_mysql(){
	
	yum -y install lftp gcc gcc-c++ autoconf 
	yum -y install libjpeg libjpeg-devel libpng libpng-devel freetype freetype-devel libxml2 libxml2-devel zlib zlib-devel glibc glibc-devel glib2 glib2-devel bzip2 bzip2-devel 
	yum -y install ncurses ncurses-devel curl curl-devel krb5 krb5-devel libidn libidn-devel openssl openssl-devel  pcre-devel

	groupadd mysql
	useradd -r -g mysql mysql
	cd /usr/local/src
	
 lftp -c "pget -n 10 $FTP_ADDR/softwares/database/mysql/cmake-2.8.4.tar.gz"
# Beginning of source-build specific instructions
tar zxvf cmake-2.8.4.tar.gz
cd cmake-2.8.4
./bootstrap
make
make install

 lftp -c "pget -n 10 $FTP_ADDR/softwares/database/mysql/bison-2.5.tar.gz"
# Beginning of source-build specific instructions
tar zxvf bison-2.5.tar.gz
cd bison-2.5
./configure
make
make install
	
	 lftp -c "pget -n 10 $FTP_ADDR/softwares/database/mysql/mysql-5.5.31.tar.gz"
	# Beginning of source-build specific instructions
	tar zxvf mysql-5.5.31.tar.gz
	cd mysql-5.5.31
	#cmake .
	
	cmake . -DCMAKE_INSTALL_PREFIX=/usr/local/mysql -DENABLED_PROFILING=ON -DMYSQL_DATADIR=/usr/local/mysql/data/ -DWITH_EXTRA_CHARSETS=all -DWITH_READLINE=ON -DWITH_DEBUG=0 -DWITH_INNOBASE_STORAGE_ENGINE=1 -DWITH_PARTITION_STORAGE_ENGINE=1 -DWITH_PERFSCHEMA_STORAGE_ENGINE=1 -DWITH_FEDERATED_STORAGE_ENGINE=1 -DENABLED_LOCAL_INFILE=1
	make && make install
	

	cp ./support-files/mysql.server /etc/init.d/mysqld
	cp ./support-files/my-large.cnf /etc/my.cnf
	
	chmod 755 /etc/init.d/mysqld
	chown -R mysql.mysql /usr/local/mysql/
	ln -s /usr/local/mysql/lib/libmysqlclient.so.18  /usr/lib/ 
	ln -s /usr/local/mysql/lib/libmysqlclient.so.18  /usr/lib64/
	
	
	/usr/local/mysql/scripts/mysql_install_db --user=mysql --basedir=/usr/local/mysql/ --datadir=/usr/local/mysql/data/ 
	
	ln -s /usr/local/mysql/bin/mysqldump /usr/sbin/mysqldump
	ln -s /usr/local/mysql/bin/mysqld_safe /usr/sbin/mysqld_safe
	ln -s /usr/local/mysql/bin/mysqlslap /usr/sbin/mysqlslap
	ln -s /usr/local/mysql/bin/mysql /usr/sbin/mysql
	ln -s /usr/local/mysql/bin/mysqladmin /usr/sbin/mysqladmin
	ln -s /usr/local/mysql/bin/mysqld /usr/sbin/mysqld
	chkconfig --add mysqld
	chkconfig mysqld on
	service mysqld start
	mysqladmin -uroot  password zdsoft

}



install_zabbix_proxy(){
	
	yum -y install curl curl-devel net-snmp net-snmp-devel perl-DBI php-gd php-xml php-bcmath
	yum -y install mysql-client mysql-server mysql-devel

	groupadd zabbix
	useradd -g zabbix zabbix
	
	if [ -f zabbix-2.0.6.tar.gz ]  ; then
		tar zxvf zabbix-2.0.6.tar.gz
	else    
	          lftp -c "pget -n 10 $FTP_ADDR/softwares/zabbix/zabbix-2.0.6.tar.gz"
	          tar zxvf zabbix-2.0.6.tar.gz
	fi   
	
	
	cd zabbix-2.0.6

./configure -prefix=/usr/local/zabbix/ --enable-proxy --enable-agent --with-mysql --with-net-snmp  --with-libcurl
make && make install	

chown -R zabbix:zabbix /usr/local/zabbix/

service mysqld restart
mysqladmin -uroot  password zdsoft

mysql -uroot -pzdsoft << EOF
create database zabbix character set utf8;
GRANT ALL ON zabbix.* TO zabbix@'localhost' IDENTIFIED BY 'zabbix';
flush privileges;
quit;

EOF

cd /usr/local/src/zabbix-2.0.6/
mysql -uzabbix -pzabbix zabbix < database/mysql/schema.sql

cp misc/init.d/fedora/core5/zabbix_agentd /etc/init.d/zabbix_agentd
cp misc/init.d/fedora/core5/zabbix_agentd /etc/init.d/zabbix_proxy

sed -i s/agentd/proxy/g /etc/init.d/zabbix_proxy
sed -i s/Agent/Proxy/g /etc/init.d/zabbix_proxy
sed -i "s#/usr/local#/usr/local/zabbix#g" /etc/init.d/zabbix_proxy
sed -i "s#/usr/local#/usr/local/zabbix#g" /etc/init.d/zabbix_agentd

chmod a+x /etc/init.d/zabbix_proxy
chmod a+x /etc/init.d/zabbix_agentd
chkconfig zabbix_proxy on
chkconfig zabbix_agentd on


echo "这里zabbix_proxy name输入在zabbix_server上设置的proxy name，如proxy_scyd,proxy_sxyd."
echo ""
echo "最后如果没有看到10051端口侦听的话，检查安装过程中是否有错误。"
echo ""
read -p "please input zabbix_proxy name[proxy_name]:" PROXY_NAME

sed -i "s#Server=127.0.0.1#Server=monitor.wanpeng.net#g" /usr/local/zabbix/etc/zabbix_proxy.conf
sed -i "s#Hostname=Zabbix proxy#Hostname=${PROXY_NAME}#g" /usr/local/zabbix/etc/zabbix_proxy.conf
sed -i 's#DBName=zabbix_proxy#DBName=zabbix#g' /usr/local/zabbix/etc/zabbix_proxy.conf
sed -i 's#DBUser=root#DBUser=zabbix#g' /usr/local/zabbix/etc/zabbix_proxy.conf
echo 'DBPassword=zabbix' >>/usr/local/zabbix/etc/zabbix_proxy.conf
#echo 'DBSocket=/tmp/mysql.sock' >> /usr/local/zabbix/etc/zabbix_proxy.conf

service zabbix_proxy start
service zabbix_agentd start

}


install_zabbix_agent(){
	
	yum -y install curl curl-devel net-snmp net-snmp-devel perl-DBI php-gd php-xml php-bcmath

	groupadd zabbix
	useradd -g zabbix zabbix
	
	if [ -f zabbix-2.0.6.tar.gz ]  ; then
		tar zxvf zabbix-2.0.6.tar.gz
	else    
	          lftp -c "pget -n 10 $FTP_ADDR/softwares/zabbix/zabbix-2.0.6.tar.gz"
	          tar zxvf zabbix-2.0.6.tar.gz
	fi   
	
	
	cd zabbix-2.0.6

./configure -prefix=/usr/local/zabbix/ --enable-agent  --with-net-snmp  --with-libcurl
make && make install	


chown -R zabbix:zabbix /usr/local/zabbix/


cp misc/init.d/fedora/core5/zabbix_agentd /etc/init.d/zabbix_agentd
chmod a+x /etc/init.d/zabbix_agentd
chkconfig zabbix_agentd on


service zabbix_agentd start

}



RETVAL=0

case "$1" in
        init_oracle_env)
                init_oracle_env
                ;;
        install_oracle)
                init_oracle_env
                download_oracle
                install_ora_app
	      set_ora_autorun			
                ;;
        install_ora_app)
	      install_ora_app
	       ;;
        create_ora_db)
                create_ora_db
                ;;
       set_ora_autorun)	
	      set_ora_autorun	
	      ;;			
        install_jdk)
                install_jdk
                ;;
        install_tomcat)
                install_tomcat
                ;;
        install_cache)
                install_cache
                ;;
        install_nginx)
                install_nginx
                ;;
	install_mysql)
	      install_mysql
                ;;		
	install_zabbix_proxy)
	      install_zabbix_proxy
	      ;;	  	
	install_zabbix_agent)
	      install_zabbix_agent
	      ;;	  		  			
	init_rhel)
		init_rhel
		 ;;
	init_yum_repo)
		init_yum_repo
		;;
	status)
		RETVAL=$?
		;;
			          *)
		 echo $"Usage: $0 {install|uninstall|reinstall|init|status   install_* }"
	RETVAL=1
     esac
exit $RETVAL				
				
