#!/usr/bin/python
# encoding=utf-8
# Filename:single.py

import time ,urllib2

def get_responses():
	urls = [
		'http://www.baidu.com',
		'http://www.zdsoft.net',
		'http://www.wanpeng.com',
	]
	start = time.time()
	for url in urls:
		print url 
		resp = urllib2.urlopen(url)
		print resp.getcode()
	print "花费时间: %s" % (time.time() - start)	

get_responses()