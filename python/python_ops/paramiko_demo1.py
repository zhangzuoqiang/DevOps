#!/usr/bin/env python
import paramiko

hostname='192.168.22.11'
username='root'
password='zdsoft.net'
paramiko.util.log_to_file('syslogin.log')

ssh=paramiko.SSHClient()
ssh.load_system_host_keys()
ssh.connect(hostname=hostname,username=username,password=password)
stdin,stdout,stderr=ssh.exec_command('free -m')
print stdout.read()
ssh.close()
