yum install ctags
wget http://soft.vpser.net/test/webbench/webbench-1.5.tar.gz
tar zxvf webbench-1.5.tar.gz
cd webbench-1.5
make && make install
webbench -c 5000 -t 120 http://www.vpser.net
#webbench -c 并发数 -t 运行测试时间 URL