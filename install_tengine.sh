#!/bin/bash
cd /usr/local/src
yum -y install pcre pcre-devel
wget http://tengine.taobao.org/download/tengine-2.0.0.tar.gz
tar zxvf tengine-2.0.0.tar.gz
cd tengine-2.0.0
./configure
make && make install
