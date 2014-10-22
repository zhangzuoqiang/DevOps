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


##oracle 用户的环境变量
cat >> /home/oracle/.bash_profile <<EOF
export ORACLE_BASE=$ORACLE_APP
export ORACLE_HOME=\$ORACLE_BASE/product/10.2.0/db_1
export ORACLE_SID=center
export PATH=\$PATH:\$ORACLE_HOME/bin:\$HOME/bin
export LD_LIBRARY_PATH=\$LD_LIBRARY_PATH:\$ORACLE_HOME/lib:/usr/lib:/usr/local/lib
export NLS_LANG=AMERICAN_AMERICA.ZHS16GBK
EOF


##执行静默安装oracle
su - oracle -c "$INSTALL_HOME/database/runInstaller -silent -responseFile $INSTALL_HOME/database/response/enterprise.rsp \
UNIX_GROUP_NAME="oinstall" ORACLE_HOME="/u01/app/oracle/product/10.2.0/db_1" \
ORACLE_HOME_NAME="OraDb10g_home1" s_nameForDBAGrp="dba" s_nameForOPERGrp="dba" n_configurationOption=3 "

rm /etc/redhat-release
cp /etc/redhat-release.orig /etc/redhat-release


echo "##########################################"
echo 'success install oracle software'