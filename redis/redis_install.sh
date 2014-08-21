cd /usr/local/src

yum install -y gcc gcc-c++ make cmake autoconf automake
wget http://redis.googlecode.com/files/redis-2.2.12.tar.gz
tar -zxvf redis-2.2.12.tar.gz
cd redis-2.2.12
make PREFIX=/usr/local/redis install

########
error: jemalloc/jemalloc.h: No such file or directory
zmalloc.h:55:2: error: 
 
#error "Newer version of jemalloc required"
make[1]: *** [adlist.o] Error 
1
make[1]: Leaving directory `/data0/src/redis-2.6.2/src'
make: *** [all] 
Error 2
 
解决办法是：
 
make MALLOC=libc