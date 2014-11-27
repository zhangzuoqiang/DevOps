#!/usr/bin/env python

import pxssh 
import sys
import getpass

try:
	s = pxssh.pxssh()
	hostname = raw_input('hostname: ')
	username = raw_input('username: ')
	password = getpass.getpass('Please input password: ')
	s.login(hostname,username,password)
	s.sendline('uptime')
	s.prompt()
	print s.before
	s.sendline('ls -l')
	s.prompt()
	print s.before
	s.sendline('df')
	s.prompt()
	print s.before
	s.logout()
except pxssh.ExceptionPxssh,e:
	print "pxssh login failed."
	print str(e)	
