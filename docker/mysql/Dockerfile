FROM centos:latest
MAINTAINER hzchenkj "hzchenkj@163.com"

RUN yum -y install mysql-server
RUN yum clean all
RUN touch /etc/sysconfig/network

ADD server.cnf /etc/my.cnf.d/server.cnf

RUN service mysqld start &&  \
	sleep 5s && \
	mysql -e "GRANT ALL PRIVILEGES ON *.* to 'root'@'%' WITH GRANT OPTION; FLUSH PRIVILEGES" && \
	mysql -e "use mysql ;UPDATE user SET password=PASSWORD('root') WHERE user='root'; FLUSH PRIVILEGES; " 

EXPOSE 3306
	
CMD ["/usr/bin/mysqld_safe"]


#docker build --rm=true --no-cache=true -t mysql-server .
#docker run -d -p 3306:3306 mysql-server