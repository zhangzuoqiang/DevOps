#prepare install oracle env
FROM centos65-ssh
##安装依赖的包
RUN yum -y install binutils compat-gcc-* compat-gcc-*-c++ compat-libstdc++-*  \
    control-center gcc gcc-c++ glibc glibc-common libstdc++ libstdc++-devel  \
    make pdksh openmotif setarch sysstat glibc-devel libgcc libaio compat-db \
    libXtst libXp libXp.i686 libXt.i686 libXtst.i686   && rm -rf /var/cache/yum 

##创建 Oracle 组和用户帐户
RUN groupadd -g 505 oinstall && groupadd -g 506 dba 
RUN useradd -u 505 -m -g oinstall -G dba oracle && id oracle

##根据需要修改以下变量
ENV ORACLE_APP /u01/app/oracle
ENV ORACLE_DATA /u02/oradata
ENV ORACLE_HOME $ORACLE_APP/product/10.2.0/db_1
ENV $INSTALL_HOME /usr/local/src

##创建目录
RUN mkdir -p $ORACLE_APP $ORACLE_DATA
RUN chown -R oracle:oinstall $ORACLE_APP $ORACLE_DATA
RUN chmod -R 775 $ORACLE_APP $ORACLE_DATA

##设置Oracle10g支持RHEL5的参数
RUN cp /etc/redhat-release /etc/redhat-release.orig

RUN echo "redhat-4" > /etc/redhat-release

ADD install.sh  $INSTALL_HOME/install.sh
ADD createdb.sh $INSTALL_HOME/createdb.sh
ADD initcenter.ora $INSTALL_HOME/initcenter.ora
ADD oracle /etc/init.d/oracle


EXPOSE 1521

#docker build -t centos65-oracle .

