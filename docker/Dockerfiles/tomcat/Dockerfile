FROM centos65base:epel
MAINTAINER chenkj <hzchenkj@163.com>
RUN yum -y install tomcat6
RUN yum -y install tomcat6-webapps
EXPOSE 8080


VOLUME ["/Users/jun/Docker_Volume"] 
ENTRYPOINT /etc/rc.d/init.d/tomcat6 start && tail -f /usr/share/tomcat6/logs/catalina.out


#docker build -t centos65:tomcat6 .
#docker run -d  -p 8080 centos65:tomcat6 
