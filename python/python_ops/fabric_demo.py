#!/usr/bin/python
#encoding=utf-8
#Filename:fabric_demo.py

from fabric.api	import *

env.hosts = ['172.16.197.130']
env.port = "22"
env.user = "root"
env.password = "123456"

def host_type():
	run('uname -s')

@runs_once
def local_task():
	local('uname -a')

def remote_task():
	with cd("/tmp"):
		run('ls -l')	

#只有列表中的第一台host 触发，要求输入目录
@runs_once
def input_raw():
    return prompt("please input directory name:",default="/home")

def worktask(dirname):
    run("ls -l "+dirname)

@task
def go():
    getdirname = input_raw()
    worktask(getdirname)



#默认文件名fabfile.py
#fab -H 172.16.197.130,172.16.197.131 -f fabric_demo.py host_type
#直接命令行执行
#fab -p 123456 -H 172.16.197.130 -- 'uname -s'  
#env.hosts=['192.168.1.11','192.168.1.9']
#env.exclude_host=['192.168.1.7']
#env.user="root"
#env.port="22"
#env.passowrd="123456"
#env.passowrds=['root@192.168.1.11:22':'123456','root@192.168.1.12:22':'12345678']
#env.gateway='192.168.1.1'  堡垒机,中转
#env.deploy_release_dir 自定义全局变量 env.+'变量名称'  env.age
