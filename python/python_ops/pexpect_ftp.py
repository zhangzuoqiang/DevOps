#!/usr/bin/python
#Filename:pexpect_ftp.py

import pexpect
child = pexpect.spawn('ftp ftp.openbsd.org')
child.expect('Name .*: ')
child.sendline('anonymous')
child.expect('Password:')
child.sendline('noah@example.com')
child.expect('ftp> ')
child.sendline('lcd /tmp')
child.expect('ftp> ')
child.sendline('cd pub/OpenBSD')
child.expect('ftp> ')
child.sendline('get README')
child.expect('ftp> ')
#child.sendline('bye')
child.sendline ('ls /pub/OpenBSD/')
child.expect ('ftp> ')
print child.before   # Print the result of the ls command.
child.interact()     # Give control of the child to the user.