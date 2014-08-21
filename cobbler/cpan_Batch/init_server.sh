#!/bin/bash
#filename init_server.sh 
tonodes /root/deploy.sh '{linux2}':/usr/local/src/
tonodes -r /opt/jdk1.6.0_38 '{linux2}':/opt/
atnodes -u root  '/usr/local/src/deploy.sh init_rhel' {linux2}
atnodes -u root  '/usr/local/src/deploy.sh install_jdk' {linux2}
atnodes -u root  'reboot' {linux2}