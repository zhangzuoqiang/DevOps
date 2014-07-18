
#mkdir centos
#cd centos
#touch Dockerfile

FROM centos
MAINTAINER chenkj <hzchenkj@163.com>
ADD http://static.theroux.ca/repository/failshell.repo /etc/yum.repos.d/
RUN yum -y install nginx
RUN echo "daemon off;" >> /etc/nginx/nginx.conf
EXPOSE 80
CMD CMD /usr/sbin/nginx -c /etc/nginx/nginx.conf


#docker build -t centos_nginx:base .
#docker images
#docker run -d -P centos_nginx:base
#docker ps
#curl http://localhost:49161