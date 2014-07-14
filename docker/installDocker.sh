#安装epel包
rpm -Uvh 'http://download.fedoraproject.org/pub/epel/6/x64/epel-release-6-3.noarch.rpm'

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





