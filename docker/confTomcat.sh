
docker pull learn/tutorial
docker run learn/tutorial /bin/echo hello world
docker run -i -t learn/tutorial /bin/bash
安装ssh 服务
apt-get update
apt-get install openssh-server
which sshd
/usr/sbin/sshd
mkdir /var/run/sshd
passwd #输入用户密码，我这里设置为123456，便于SSH客户端登陆使用
exit #退出

获取到刚才操作的实例容器ID
docker ps -l
CONTAINER ID IMAGE COMMAND CREATED STATUS PORTS NAMES
51774a81beb3 learn/tutorial:latest /bin/bash 3 minutes ago Exit 0 thirsty_pasteur

#一旦进行所有操作，都需要提交保存，便于SSH登陆使用：
docker commit 51774a81beb3 learn/java

#以后台进程方式长期运行此镜像实例：
docker run -d -p 22 -p 80:8080 learn/java /usr/sbin/sshd -D
# 22 是ssh sever tomcat 是8080端口 ，对外是80

#是否成功运行。
docker ps

#这里的分配随机的SSH连接端口号为49154：
ssh root@127.0.0.1 -p 49154

#安装jdk tomcat
apt-get install -y wget
apt-get install oracle-java7-installer
java -version
# 下载tomcat 7.0.47
wget http://mirror.bit.edu.cn/apache/tomcat/tomcat-7/v7.0.47/bin/apache-tomcat-7.0.47.tar.gz
# 解压，运行
tar xvf apache-tomcat-7.0.47.tar.gz
cd apache-tomcat-7.0.47
bin/startup.sh



#centos

yum install openssh openssh-server 
yum install net-tools

which sshd
/usr/sbin/sshd
ssh-keygen -t rsa -b 2048 -f /etc/ssh/ssh_host_rsa_key
ssh-keygen -t ecdsa -f /etc/ssh/ssh_host_ecdsa_key -N ""




ssh_exchange_identification: Connection closed by remote host  
 
解决办法：
修改/etc/hosts.allow文件，加入 sshd:ALL，然后重启sshd服务.
修改/etc/hosts.deny, 将 ALL: ALL 注释掉.
