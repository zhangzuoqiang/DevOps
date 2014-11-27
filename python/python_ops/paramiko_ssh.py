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

port=22
passinfo='\'s password: '
paramiko.util.log_to_file('syslogin_paramiko_ssh.log')

ssh=paramiko.SSHClient()
ssh.set_missing_host_key_policy(paramiko.AutoAddPolicy())
#连接堡垒机
ssh.connect(hostname=blip,username=bluser,password=blpasswd)

#new session
channel=ssh.invoke_shell()
channel.settimeout(10)

buff = ''
resp = ''
#登录业务主机
channel.send('ssh '+username+'@'+hostname+'\n')

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

#发送业务主机密码
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

#发送命令
channel.send('ifconfig\n')
buff=''
try: 
    while buff.find('# ')==-1:
        resp = channel.recv(9999)
        buff += resp
except Exception, e:
    print "error info:"+str(e)

#打印
print buff
channel.close()
ssh.close()
