#!/bin/sh

#  installMaster.sh
#  
#
#  Created by chen kejun on 14-6-27.
#

#关闭selinux

#ifconfig |grep inet| sed -n '1p'|awk '{print $2}'|awk -F ':' '{print $2}'

#设置epel 源
rpm -ivh https://yum.puppetlabs.com/el/6/products/x86_64/puppetlabs-release-6-10.noarch.rpm
rpm -ivh http://yum.puppetlabs.com/puppetlabs-release-el-6.noarch.rpm

rpm -ivh http://mirrors.aliyun.com/centos/6.5/os/x86_64/Packages/ruby-libs-1.8.7.352-12.el6_4.x86_64.rpm
rpm -ivh http://mirrors.aliyun.com/centos/6.5/os/x86_64/Packages/ruby-1.8.7.352-12.el6_4.x86_64.rpm
rpm -ivh http://mirrors.aliyun.com/centos/6.5/os/x86_64/Packages/ruby-irb-1.8.7.352-12.el6_4.x86_64.rpm
rpm -ivh http://mirrors.aliyun.com/centos/6.5/os/x86_64/Packages/ruby-rdoc-1.8.7.352-12.el6_4.x86_64.rpm
rpm -ivh http://mirrors.aliyun.com/centos/6.5/os/x86_64/Packages/rubygems-1.3.7-5.el6.noarch.rpm

#服务端安装
yum -y install ruby ruby-libs ruby-shadow  ruby-rdoc  puppet puppet-server facter 
#客户端安装
yum -y install ruby ruby-libs ruby-shadow puppet facter

#修改hostname
hostname master.domain.com
hostname agent.domain.com
sed -i 's/localhost.localdomain/master.domain.com/g' /etc/sysconfig/network
sed -i 's/localhost.localdomain/agent.domain.com/g' /etc/sysconfig/network



cat >> /etc/hosts <<EOF
#use for puppet
192.168.32.152 master.domain.com
192.168.32.148  agent.domain.com
EOF

master:
service  puppetmaster start
chkconfig puppetmaster on
tail -f /var/log/puppet/masterhttp.log
agent:
puppet agent --test --server master.domain.com

master:

puppet cert list
puppet cert list -all
puppet cert sign agent.domain.com

#查看本地证书
tree /var/lib/puppet/ssl/
#查看服务端口
netstat -nlatp | grep 8140

服务器端验证
puppet parser validate /etc/puppet/modules/base/manifests/init.pp

客户端测试
puppet  agent  --test

puppet master --genconfig >/etc/puppet/puppet.conf.out

#environment  development,testing,production

vi /etc/puppet/puppet.conf
[master]
environment = development,testing,production

[development]
manifest = /etc/puppet/manifest/development/site.pp
modulepath = /etc/puppet/modulepath/development
fileserverconfig = /etc/puppet/fileserver.conf.development

[testing]
manifest = /etc/puppet/manifest/testing/site.pp
modulepath = /etc/puppet/modulepath/testing
fileserverconfig = /etc/puppet/fileserver.conf.testing

[production]
manifest = /etc/puppet/manifest/production/site.pp
modulepath = /etc/puppet/modulepath/production
fileserverconfig = /etc/puppet/fileserver.conf.production


#git
yum -y install git git-daemon
mkdir -p /tmp/puppet_repo/puppet.git
cd /tmp/puppet_repo/puppet.git
#创建git仓库
git --bare init
chown -R daemon:daemon /tmp/puppet_repo
#daemon启动git
git daemon --base-path=/tmp/puppet_repo --detach --user=daemon \
--listen=127.0.0.1 --group=daemon --export-all --enable=receive-pack \
--enable=upload-pack --enable=upload-archive

## 将/etc/puppet 加入到 git
cd /tmp/
git clone git://127.0.0.1/puppet.git puppet
cd puppet
cp -r /etc/puppet/* .
git add -A
git commit -m "add puppet to git."

#提交到版本库，主分支
git push origin master

rm -rf /etc/puppet
cd /etc
git clone git://127.0.0.1/puppet.git puppet





