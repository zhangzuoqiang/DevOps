#!/usr/bin/python
#Filename:pexpect_ssh.py

import pexpect
import sys

shell_cmd = 'ls -l |grep py > logs.txt'
child = pexpect.spawn('/bin/bash',['-c',shell_cmd])
child.expect(pexpect.EOF)

child_log = pexpect.spawn('ls -l /')
fout = file('mylog.txt','w')
#child_log.logfile = fout
child_log.logfile = sys.stdout

child = pexpect.spawn('scp pexpect_ssh.py root@192.168.22.11:.')
# Wait no more than 2 minutes (120 seconds) for password prompt.
#child.expect('password:', timeout=120)
child.expect('password:')
mypassword ='zdsoft.net'
child.sendline(mypassword)

child = pexpect.spawn('/usr/bin/ssh root@192.168.22.11')
child.expect('password:')
child.sendline(mypassword)
i = child.expect (['Permission denied', 'Terminal type', '[#\$] '])
if i==0:
    print("Permission denied on host. Can't login")
    child.kill(0)
elif i==2:
    print('Login OK... need to send terminal type.')
    child.sendline('vt100')
    child.expect('[#\$] ')
elif i==3:
    print('Login OK.')
    print('Shell command prompt', child.after)
