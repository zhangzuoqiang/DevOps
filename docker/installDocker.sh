#安装epel包
rpm -Uvh 'http://download.fedoraproject.org/pub/epel/6/x64/epel-release-6-3.noarch.rpm'
http://mirrors.yun-idc.com/epel/6/x86_64/epel-release-6-8.noarch.rpm

#安装docker-io在我们的主机上
sudo yum -y install docker-io
#升级docker-io包
sudo yum -y update docker-io
#开始docker进程,启动服务
sudo service docker start
#开机启动
sudo chkconfig docker on
#现在让我们确认一下docker是否工作了
sudo docker run -i -t fedora /bin/bash
#运行了，OK你现在去运行hello word的实例吧
#运行例子

#所有的实例都需要在机器中运行docker进程，后台运行docker进程，简单演示
sudo docker -d &
#现在你可以运行Docker客户端，默认情况下所有的命令都会经过一个受保护的Unix #socket转发给docker进程,所以我们必须运行root或者通过sudo授权。

sudo docker help

#下载busybox镜像，他是最小的linux系统，这个镜像可以从docker仓库获取！
sudo docker pull busybox


#下载ubuntu base镜像
sudo docker pull ubuntu
sudo docker run ubuntu /bin/echo hello world

这个命令会运行一个简单的echo 命令，控制台就输出"hello word"

讲解:

sudo 执行root权限
docker run 运行一个新的容器
ubuntu 我们想要在内部运行命令的镜像
/bin/echo 我们想要在内部运行的命令
hello word 输出的内容




1、下载官方制作的CentOS6.4镜像

docker pull centos
输出大致如下：


Pulling repository centos
539c0211cd76: Downloading 67.96 MB/98.56 MB (69%)
539c0211cd76: Download complete
下载的镜像位于/var/lib/docker/devicemapper/mnt/539c0211cd76*/rootfs/

2、查看安装好的虚拟机


# docker images
输出如下
REPOSITORY          TAG                 IMAGE ID            CREATED             SIZE
centos              6.4                 539c0211cd76        8 months ago        300.6 MB (virtual 300.6 MB)
3、接下来我们在centos 6.4的环境下执行一个top命令，然后查看输出


# ID=$( docker run -d centos /usr/bin/top -b)
# docker attach $ID
输出如下
top - 23:30:50 up 47 min,  0 users,  load average: 0.14, 0.44, 0.53
Tasks:   1 total,   1 running,   0 sleeping,   0 stopped,   0 zombie
Cpu(s):  4.6%us,  1.0%sy,  0.0%ni, 91.6%id,  2.8%wa,  0.0%hi,  0.0%si,  0.0%st

4、杀死这个虚拟机


# docker stop $ID
5、进入虚拟机的shell，干你想干的任何事情


# docker run -i -t centos /bin/bash
 

6、官方的这个centos镜像非常小，不到100M，如果需要配置一个复杂的环境，请直接yum解决。

docker 也提供了在线搜索镜像模板功能，类似与puppet在线安装模板（步骤1）


# docker search ubuntu
# docker search centos
# docker search debian
通过网页搜索模板 https://index.docker.io/
docker ps 
docker ps -a
#查看详细
docker ps -l 

 boot2docker ip
 # log tail -f
 docker logs -f $ID 
 #查看进程
 docker top $ID
 docker inspect $ID
docker rm $ID


docker images



