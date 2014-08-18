FROM ubuntu:14.04
MAINTAINER chenkj <hzchenkj@163.com>

RUN echo "deb http://mirrors.163.com/ubuntu/ trusty main restricted" > /etc/apt/sources.list

RUN apt-get -qq update
RUN apt-get install -y vim curl wget lftp
RUN apt-get install -y ping
RUN apt-get install -y mysql-server mysql-client

EXPOSE 3306
CMD ["/usr/bin/mysqld_safe"]

