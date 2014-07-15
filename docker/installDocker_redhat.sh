介绍如何在RedHat/CentOS环境下，安装新版本的Docker。

一、禁用selinux
由于Selinux和LXC有冲突，所以需要禁用selinux。编辑/etc/selinux/config，设置两个关键变量。    
SELINUX=disabled 
SELINUXTYPE=targeted
二、配置Fedora EPEL源

sudo yum install http://ftp.riken.jp/Linux/fedora/epel/6/x86_64/epel-release-6-8.noarch.rpm
http://mirrors.yun-idc.com/epel/6/i386/epel-release-6-8.noarch.rpm
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