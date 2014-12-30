#!/usr/bin/python
# encoding=utf-8
# Filename:single.py

import time ,urllib2
from threading import Thread

class UrlThread(Thread):
	def __init__(self,url):
		self.url = url
		super(UrlThread,self).__init__()

	def run(self):
		resp = urllib2.urlopen(self.url)
		print self.url,resp.getcode()

def get_responses():
	urls = [
		'http://www.baidu.com',
		'http://www.zdsoft.net',
		'http://www.wanpeng.com',
		'http://www.taobao.com',
		'http://www.tmall.com'
	]
	start = time.time()
    end = time.time()
	threads = []
	for url in urls:
		t = UrlThread(url)
		threads.append(t)
		t.start()
	for t in threads:
		t.join() 
	print "花费时间: %s" % (time.time() - start)	

get_responses()