#!/usr/bin/env python

import pexpect 
import sys

child = pexpect.spawn('ssh root@192.168.22.11')
fout = file('mysshlog.txt','w')
#child.logifle = fout
#child.logifle = sys.stdout

child.expect("password:")
child.sendline("zdsoft.net")
child.expect("#")
child.sendline("ls /home")
child.expect("#")
sys.stdout.write(child.before)