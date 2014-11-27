# -*- coding: utf-8 -*-
import os,sys
import time
import sys
import pycurl

#URL ="www.baidu.com"
URL="http://www.wanpeng.com"
if len(sys.argv) >1 :
	URL = sys.argv[1]
print URL
#URL="http://open.wanpeng.com/app/getMyApps.htm?ticket=ticket&userId=8A18E09E4724FB9901476347B3AD4C7F&device=1"
#URL="http://open180.weike.wanpeng.com/group/getShareContentByGroupId.htm?groupId=8A18E0A94840E3840148633AC4C32D99&userId=402881994563444701456434B2E1003F&ticket=ticket0"
#URL="http://www.google.com.hk"
c = pycurl.Curl()
c.setopt(pycurl.URL, URL)
                
#连接超时时间,5秒
c.setopt(pycurl.CONNECTTIMEOUT, 10)

#下载超时时间,5秒
c.setopt(pycurl.TIMEOUT, 10)
c.setopt(pycurl.FORBID_REUSE, 1)
c.setopt(pycurl.MAXREDIRS, 1)
c.setopt(pycurl.NOPROGRESS, 1)
c.setopt(pycurl.DNS_CACHE_TIMEOUT,30)
indexfile = open(os.path.dirname(os.path.realpath(__file__))+"/content.txt", "wb")
c.setopt(pycurl.WRITEHEADER, indexfile)
c.setopt(pycurl.WRITEDATA, indexfile)
try:
    c.perform()
except Exception,e:
    print "connecion error:"+str(e)
    indexfile.close()
    c.close()
    sys.exit()

NAMELOOKUP_TIME =  c.getinfo(c.NAMELOOKUP_TIME)
CONNECT_TIME =  c.getinfo(c.CONNECT_TIME)
PRETRANSFER_TIME =   c.getinfo(c.PRETRANSFER_TIME)
STARTTRANSFER_TIME = c.getinfo(c.STARTTRANSFER_TIME)
TOTAL_TIME = c.getinfo(c.TOTAL_TIME)
HTTP_CODE =  c.getinfo(c.HTTP_CODE)
SIZE_DOWNLOAD =  c.getinfo(c.SIZE_DOWNLOAD)
HEADER_SIZE = c.getinfo(c.HEADER_SIZE)
SPEED_DOWNLOAD=c.getinfo(c.SPEED_DOWNLOAD)

print "HTTP状态码：%s" %(HTTP_CODE)
print "DNS解析时间：%.2f ms"%(NAMELOOKUP_TIME*1000)
print "建立连接时间：%.2f ms" %(CONNECT_TIME*1000)
print "准备传输时间：%.2f ms" %(PRETRANSFER_TIME*1000)
print "传输开始时间：%.2f ms" %(STARTTRANSFER_TIME*1000)
print "传输结束总时间：%.2f ms" %(TOTAL_TIME*1000)

print "下载数据包大小：%d bytes/s" %(SIZE_DOWNLOAD)
print "HTTP头部大小：%d byte" %(HEADER_SIZE)
print "平均下载速度：%d bytes/s" %(SPEED_DOWNLOAD)

indexfile.close()
c.close()

