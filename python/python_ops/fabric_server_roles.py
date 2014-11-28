#!/usr/bin/env python
from fabric.colors import *
from fabric.api import *

env.user='root'
env.roledefs = {
    'webservers': ['192.168.22.11', '192.168.22.12'],
    'dbservers': ['192.168.23.8']
}

env.passwords = {
    'root@192.168.22.11:22': 'zdsoft.net',
    'root@192.168.22.12:22': 'zdsoft.net',
    'root@192.168.23.8:22': 'zdsoft.net'
}

@roles('webservers')
def webtask():
    print yellow("Install nginx ...")
    with settings(warn_only=True):
        run("yum -y install nginx")
        run("chkconfig --levels 235 nginx on")

@roles('dbservers')
def dbtask():
    print yellow("Install Mysql...")
    with settings(warn_only=True):
        run("yum -y install mysql mysql-server")
        run("chkconfig --levels 235 mysqld on")

@roles ('webservers', 'dbservers')
def publictask():
    print yellow("Install epel ntp...")
    with settings(warn_only=True):
        run("rpm -Uvh http://dl.fedoraproject.org/pub/epel/6/x86_64/epel-release-6-8.noarch.rpm")
        run("yum -y install ntp")

def deploy():
    execute(publictask)
    execute(webtask)
    execute(dbtask)
