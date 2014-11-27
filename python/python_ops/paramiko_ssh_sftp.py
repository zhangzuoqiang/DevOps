#!/usr/bin/env python
#encoding=utf-8

import paramiko
import os,sys,time

#堡垒机
blip="192.168.22.11"
bluser="root"
blpasswd="zdsoft.net"

#业务服务器
hostname="192.168.22.12"
username="root"
password="zdsoft.net"

tmpdir="/home/winupon"
remotedir="/home/winupon"
localpath="/Users/hzchenkj/DevOps/python/python_ops/pexpect_ssh_scp.py"
tmppath=tmpdir+"/pexpect_ssh_scp.py.tar.gz"
remotepath=remotedir+"/pexpect_ssh_scp_hd.py.tar.gz"

port=22
passinfo='\'s password: '
paramiko.util.log_to_file('syslogin.log')

t = paramiko.Transport((blip, port))
t.connect(username=bluser, password=blpasswd)
sftp =paramiko.SFTPClient.from_transport(t)
sftp.put(localpath, tmppath)
sftp.close()

ssh=paramiko.SSHClient()
ssh.set_missing_host_key_policy(paramiko.AutoAddPolicy())
ssh.connect(hostname=blip,username=bluser,password=blpasswd)

#new session
channel=ssh.invoke_shell()
channel.settimeout(10)

buff = ''
resp = ''
channel.send('scp '+tmppath+' '+username+'@'+hostname+':'+remotepath+'\n')

while not buff.endswith(passinfo):
    try:
        resp = channel.recv(9999)
    except Exception,e:
        print 'Error info:%s connection time.' % (str(e))
        channel.close()
        ssh.close()
        sys.exit()
    buff += resp
    if not buff.find('yes/no')==-1:
        channel.send('yes\n')
	buff=''

channel.send(password+'\n')

buff=''
while not buff.endswith('# '):
    resp = channel.recv(9999)
    if not resp.find(passinfo)==-1:
        print 'Error info: Authentication failed.'
        channel.close()
        ssh.close()
        sys.exit() 
    buff += resp

print buff
channel.close()
ssh.close()
