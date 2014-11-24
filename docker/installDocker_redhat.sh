介绍如何在RedHat/CentOS环境下，安装新版本的Docker。


http://mirrors.aliyun.com/epel/6/x86_64/docker-io-1.2.0-3.el6.x86_64.rpm
wget http://mirrors.aliyun.com/epel/6/x86_64/lxc-1.0.6-1.el6.x86_64.rpm
wget http://mirrors.aliyun.com/epel/6/x86_64/lua-alt-getopt-0.7.0-1.el6.noarch.rpm
wget http://mirrors.aliyun.com/epel/6/x86_64/lua-lxc-1.0.6-1.el6.x86_64.rpm
wget http://mirrors.aliyun.com/epel/6/x86_64/lxc-devel-1.0.6-1.el6.x86_64.rpm
wget http://mirrors.aliyun.com/epel/6/x86_64/lxc-libs-1.0.6-1.el6.x86_64.rpm
wget http://mirrors.aliyun.com/epel/6/x86_64/lua-filesystem-1.4.2-1.el6.x86_64.rpm
wget  http://mirrors.aliyun.com/centos/6/os/x86_64/Packages/lftp-4.0.9-1.el6_5.1.x86_64.rpm

#!/bin/bash
mv /etc/yum.repos.d/CentOS-Base.repo /etc/yum.repos.d/CentOS-Base.repo.backup
wget -O /etc/yum.repos.d/CentOS-Base.repo http://mirrors.aliyun.com/repo/Centos-6.repo
mv /etc/yum.repos.d/epel.repo /etc/yum.repos.d/epel.repo.backup
mv /etc/yum.repos.d/epel-testing.repo /etc/yum.repos.d/epel-testing.repo.backup
wget -O /etc/yum.repos.d/epel.repo http://mirrors.aliyun.com/repo/epel-6.repo
yum makecache

一、禁用selinux
由于Selinux和LXC有冲突，所以需要禁用selinux。编辑/etc/selinux/config，设置两个关键变量。    
SELINUX=disabled 
SELINUXTYPE=targeted
二、配置Fedora EPEL源

sudo yum install http://ftp.riken.jp/Linux/fedora/epel/6/x86_64/epel-release-6-8.noarch.rpm
http://mirrors.yun-idc.com/epel/6/i386/epel-release-6-8.noarch.rpm
http://mirrors.yun-idc.com/epel/beta/7/x86_64/epel-release-7-0.2.noarch.rpm
三、添加hop5.repo源


cd /etc/yum.repos.d 
sudo wget http://www.hop5.in/yum/el6/hop5.repo
四、安装Docker

sudo yum install docker-io
可以发现安装的软件只有docker和lxc相关包，没有内核包，例如kernel-ml-aufs。

五、初步验证docker
  输入docker -h，如果有如下输出，就证明docker在形式上已经安装成功。

# docker -h 


六、手动挂载cgroup
  在RedHat/CentOS环境中运行docker、lxc，需要手动重新挂载cgroup。
  我们首选禁用cgroup对应服务cgconfig。

sudo service cgconfig stop # 关闭服务 
sudo chkconfig cgconfig off # 取消开机启动
  然后挂载cgroup，可以命令行挂载

mount -t cgroup none /cgroup # 仅本次有效
  或者修改配置文件，编辑/etc/fstab，加入

none /cgroup cgroup defaults 0 0 # 开机后自动挂载，一直有效
七、调整lxc版本
  Docker0.7默认使用的是lxc-0.9.0，该版本lxc在redhat上不能正常运行，需要调整lxc版本为lxc-0.7.5或者lxc-1.0.0Beta2。前者可以通过lxc网站（http://sourceforge.net/projects/lxc/files/lxc/）下载，后者需要在github上下载最新的lxc版本（https://github.com/lxc/lxc，目前版本是lxc-1.0.0Beta2）。
这里特别说明一点，由于Docker安装绝对路径/usr/bin/lxc-xxx调用lxc相关命令，所以需要将lxc-xxx安装到/usr/bin/目录下。


八、启动docker服务


sudo service docker start # 启动服务 
sudo chkconfig docker on  # 开机启动
九、试运行

sudo docker run -i -t Ubuntu /bin/echo hello world
  初次执行此命令会先拉取镜像文件，耗费一定时间。最后应当输出hello world。
  
  
  
  　　报错：unable to remount sys readonly: unable to mount sys as readonly max retries reached
  在CentOS下还需要修改相应的配置文件。

  　　需要把/etc/sysconfig/docker文件中的other-args更改为：

  　　other_args="--exec-driver=lxc --selinux-enabled"    
  
  
   #centos
  yum install initscripts wget lftp openssh-server net-tools passwd
  
  which sshd
  /usr/sbin/sshd
  ssh-keygen -t rsa -b 2048 -f /etc/ssh/ssh_host_rsa_key
  ssh-keygen -t ecdsa -f /etc/ssh/ssh_host_ecdsa_key -N ""
  
  useradd docker
  passwd docker
  
  docker run -d -p 22 -p 9090:8080 centos /usr/sbin/sshd -D
  docker run -d -P --name web training/webapp python app.py
  
  docker ps -l
  
  四. docker镜像迁移

  镜像导出：
  docker save IMAGENAME | bzip2 -9 -c>img.tar.bz2
  镜像导入：
  bzip2 -d -c <img.tar.bz2 | docker load