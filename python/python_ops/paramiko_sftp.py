#!/usr/bin/env python
import paramiko

hostname='192.168.22.11'
username='root'
password='zdsoft.net'
port=22

try:
	t = paramiko.Transport(hostname,port)
	t.connect(username=username,password=password)
	sftp = paramiko.SFTPClient.from_transport(t)

	sftp.mkdir("/root/test_python",0755)
	sftp.put("paramiko_sftp.py","/root/test_python/paramiko_sftp.py")
	sftp.get("/root/test_python/paramiko_sftp.py","/Users/hzchenkj/DevOps/python/python_ops/paramiko_sftp_1.py")
	sftp.rename("/root/test_python/paramiko_sftp.py","/root/test_python/paramiko_sftp_2.py")
	print sftp.stat("/root/test_python/paramiko_sftp.py")
	print sftp.listdir("/root/test_python")
	t.close()
except Exception,e:
	print str(e)	