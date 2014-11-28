#!/usr/bin/python
#encoding=utf-8
#Filename:fabric_gateway.py

from fabric.api import * 
from fabric.context_managers import * 
from fabric.contrib.console import confirm

env.user = 'root'
env.gateway = '192.168.23.8'
env.hosts = ['192.168.22.11','192.168.22.12']
env.passwords ={
	'root@192.168.22.11:22':'zdsoft.net',
	'root@192.168.22.12:22':'zdsoft.net'
}

lpath = '/Users/hzchenkj/Dev/Python/pexpect-3.3.tar.gz'
rpath = '/tmp/install'

@task
def put_task():
	run('mkdir -p /tmp/install')
	with settings(warn_only=True):
		result = put(lpath,rpath)
	if result.failed and not confirm("put file failed,Continue[Y/N]?"):	
		abort("Aborting file put task!!")

@task 
def run_task():
	with cd("/tmp/install"):
		run("tar zxvf dnspython-1.12.0.tar.gz ")
		with cd("dnspython-1.12.0"):
			run("python setup.py install")

@task
def go():
	put_task()
	run_task()
		