# create oracle db 
chown -R oracle:oinstall /u02

su - oracle -c 'mkdir -p /u01/app/oracle/product/10.2.0/db_1/dbs'
su - oracle -c 'mkdir -p /u02/oradata/admin/center/adump'
su - oracle -c 'mkdir -p /u02/oradata/admin/center/bdump'
su - oracle -c 'mkdir -p /u02/oradata/admin/center/cdump'
su - oracle -c 'mkdir -p /u02/oradata/admin/center/pfile'
su - oracle -c 'mkdir -p /u02/oradata/admin/center/udump'
su - oracle -c 'mkdir -p /u02/oradata/center'
su - oracle -c 'mkdir -p /u02/oradata/center/archive'


cp $INSTALL_HOME/initcenter.ora /u02/oradata/admin/center/pfile
cp $INSTALL_HOME/initcenter.ora /u01/app/oracle/product/10.2.0/db_1/dbs



chown oracle:oinstall /u02/oradata/admin/center/pfile/initcenter.ora
chmod a+x /u02/oradata/admin/center/pfile/initcenter.ora
chown oracle:oinstall /u01/app/oracle/product/10.2.0/db_1/dbs/initcenter.ora
chmod a+x /u01/app/oracle/product/10.2.0/db_1/dbs/initcenter.ora

echo 'success cp file ,begin to sqlplus ...'

echo 506 > /proc/sys/vm/hugetlb_shm_group

su - oracle -c 'sqlplus / as sysdba' << EOF
startup nomount pfile=/u02/oradata/admin/center/pfile/initcenter.ora
EOF
echo 'sucecess startup database in nomount state'

su - oracle -c 'sqlplus / as sysdba' << EOF
CREATE DATABASE center
LOGFILE
GROUP 1 ('/u02/oradata/center/redo01.log','/u02/oradata/center/redo01_1.log') size 50m reuse,
GROUP 2 ('/u02/oradata/center/redo02.log','/u02/oradata/center/redo02_1.log') size 50m reuse,
GROUP 3 ('/u02/oradata/center/redo03.log','/u02/oradata/center/redo03_1.log') size 50m reuse
MAXLOGFILES 50
MAXLOGMEMBERS 5
MAXLOGHISTORY 200
MAXDATAFILES 50
MAXINSTANCES 5
CHARACTER SET ZHS16GBK
NATIONAL CHARACTER SET AL16UTF16
DATAFILE '/u02/oradata/center/system01.dbf' SIZE 50M autoextend on next 10M maxsize 1024M
SYSAUX DATAFILE '/u02/oradata/center/sysaux01.dbf' SIZE 50M autoextend on next 10M maxsize 1024M
UNDO TABLESPACE UNDOTS DATAFILE '/u02/oradata/center/undo.dbf' SIZE 50M autoextend on next 10M maxsize 1024M 
DEFAULT TEMPORARY TABLESPACE TEMP TEMPFILE '/u02/oradata/center/temp.dbf' SIZE 50M autoextend on next 10M maxsize 1024M;


@/u01/app/oracle/product/10.2.0/db_1/rdbms/admin/catalog.sql
@/u01/app/oracle/product/10.2.0/db_1/rdbms/admin/catproc.sql
conn system/manager
@/u01/app/oracle/product/10.2.0/db_1/sqlplus/admin/pupbld.sql
EOF

su - oracle -c 'sqlplus / as sysdba' << EOF
shutdown immediate;
startup mount;    
alter database archivelog; 
alter database open;   
archive log list;   

EOF

cat >> /etc/oratab << EOF

center:/u01/app/oracle/product/10.2.0/db_1:Y

EOF

chmod 755 /etc/init.d/oracle
#4添加服务
chkconfig --level 35 oracle on

#5. 需要在关机或重启机器之前停止数据库，做一下操作
ln -s /etc/init.d/oracle /etc/rc0.d/K01oracle   //关机
ln -s /etc/init.d/oracle /etc/rc6.d/K01oracle   //重启 



