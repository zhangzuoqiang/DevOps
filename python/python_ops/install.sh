
yum install python-rrdtool
yum install python-devel
wget https://pypi.python.org/packages/source/p/psutil/psutil-2.1.3.tar.gz#md5=015a013c46bb9bc30b5c344f26dea0d3
tar psutil-2.1.3.tar.gz
cd psutil-2.1.3
python setup.py install

*/5 * * * * /usr/bin/python /root/python/rrdtool/update.py > /dev/null 2>&1

wget https://pypi.python.org/packages/source/p/python-nmap/python-nmap-0.3.4.tar.gz