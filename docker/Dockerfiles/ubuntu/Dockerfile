FROM ubuntu:14.04
MAINTAINER chenkj <hzchenkj@163.com>

RUN apt-get update
RUN apt-get install -y sun-java6-jdk tomcat6
RUN apt-get install -y vim curl ping wget lftp
RUN apt-get install -y memcached
RUN apt-get install -y mysql-server mysql-client
CMD memcached -u root -p 11211
