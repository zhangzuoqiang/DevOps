
rpm --nosignature -i https://repo.varnish-cache.org/redhat/varnish-3.0.el6.rpm
yum install varnish



#创建www用户和组，以及Varnish缓存文件存放目录（/var/vcache）：
/usr/sbin/groupadd www -g 48
/usr/sbin/useradd -u 48 -g www www
mkdir -p /var/vcache
chmod +w /var/vcache
chown -R www:www /var/vcache

#创建Varnish日志目录（/var/logs/）：
mkdir -p /var/logs
chmod +w /var/logs
chown -R www:www /var/logs

#编译安装varnish：
cd /usr/local/src
wget http://repo.varnish-cache.org/source/varnish-3.0.5.tar.gz

yum install  automake autoconf groff libedit-devel libtool ncurses-devel pcre-devel pkgconfig python-docutils

tar zxvf varnish-3.0.5.tar.gz
cd varnish-3.0.5
sh autogen.sh
sh configure
make

cp redhat/varnish.initrc  /etc/init.d/varnish
cp redhat/varnish.sysconfig  /etc/sysconfig/varnish


#/etc/varnish/default.vcl
#默认配置文件

service  varnish start

# 浏览器访问 http://127.0.0.1:6081/ 

#创建Varnish配置文件：
vi /usr/local/varnish/vcl.conf

#启动varnish
ulimit -SHn 51200
/usr/local/varnish/sbin/varnishd -n /var/vcache -f /usr/local/varnish/vcl.conf -a 0.0.0.0:80 \
	-s file,/var/vcache/varnish_cache.data,1G -g www -u www -w 30000,51200,10 -T 127.0.0.1:3500 -p client_http11=on

#启动varnishncsa用来将Varnish访问日志写入日志文件：
/usr/local/varnish/bin/varnishncsa -n /var/vcache -w /var/logs/varnish.log &

#配置开机自动启动Varnish
cat >> /etc/rc.local <<EOF
ulimit -SHn 51200
/usr/local/varnish/sbin/varnishd -n /var/vcache -f /usr/local/varnish/vcl.conf -a 0.0.0.0:80 -s file,/var/vcache/varnish_cache.data,1G -g www -u www -w 30000,51200,10 -T 127.0.0.1:3500 -p client_http11=on
/usr/local/varnish/bin/varnishncsa -n /var/vcache -w /var/logs/youvideo.log &
EOF

#优化Linux内核参数
cat >> /etc/sysctl.conf <<EOF
net.ipv4.tcp_fin_timeout = 30
net.ipv4.tcp_keepalive_time = 300
net.ipv4.tcp_syncookies = 1
net.ipv4.tcp_tw_reuse = 1
net.ipv4.tcp_tw_recycle = 1
net.ipv4.ip_local_port_range = 5000    65000
EOF


#查看Varnish服务器连接数与命中率：
/usr/local/varnish/bin/varnishstat


varnishtop -i rxurl
varnishtop -i txurl
varnishtop -i RxHeader -I Accept-Encoding

varnishhist
#Hits are marked with a pipe character ("|"), 
#and misses are marked with a hash character ("#")
