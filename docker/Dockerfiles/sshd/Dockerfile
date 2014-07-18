
cat /usr/local/src/sshd/Dockerfile << EOF
# Version: 0.0.1
FROM ubuntu:14.04
MAINTAINER chenkj <hzchenkj@163.com>
RUN rm -rf /etc/apt/sources.list
RUN echo "deb http://mirrors.163.com/ubuntu/ trusty main multiverse restricted universe" >> /etc/apt/sources.list 
RUN echo  "deb http://mirrors.163.com/ubuntu/ trusty-security main multiverse restricted universe" >> /etc/apt/sources.list 
RUN echo  "deb http://mirrors.163.com/ubuntu/ trusty-updates main multiverse restricted universe" >> /etc/apt/sources.list  
RUN echo  "deb http://mirrors.163.com/ubuntu/ trusty-proposed universe restricted multiverse main" >> /etc/apt/sources.list  
RUN echo  "deb http://mirrors.163.com/ubuntu/ trusty-backports main multiverse restricted universe" >> /etc/apt/sources.list   

RUN apt-get update

RUN apt-get install -y openssh-server
RUN mkdir /var/run/sshd
RUN useradd test
RUN echo "test:123456" | chpasswd
RUN echo "root:123456" | chpasswd
EXPOSE 22
CMD    ["/usr/sbin/sshd", "-D"]

EOF


$ sudo docker run -d -P --name test_sshd eg_sshd
$ sudo docker port test_sshd 22
$ ssh root@192.168.1.2 -p 49154