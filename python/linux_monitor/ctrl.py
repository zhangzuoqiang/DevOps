#!/usr/bin/env Python 
import os, sys, time 

while True: 
	time.sleep(4) 
	try: 
		ret = os.popen('ps -C httpd -o pid,cmd').readlines() 
		if len(ret) < 2: 
			print "apache proc exception exit,restart after  4 seconds" 
		time.sleep(3) 
		os.system("service httpd restart") 
	except: 
		print "Error", sys.exc_info()[1]
