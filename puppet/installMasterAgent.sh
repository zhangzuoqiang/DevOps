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

#服务端安装
yum -y install ruby ruby-libs ruby-shadow puppet puppet-server facter
#客户端安装
yum -y install ruby ruby-libs ruby-shadow puppet facter

#修改hostname
hostname master.domain.com
hostname agent.domain.com
sed -i 's/localhost.localdomain/master.domain.com/g' /etc/sysconfig/network
sed -i 's/localhost.localdomain/agent.domain.com/g' /etc/sysconfig/network



cat >> /etc/hosts <<EOF
#use for puppet
192.168.32.137 master.domain.com
192.168.32.142  agent.domain.com
EOF

master:
service  puppetmaster start
tail -f /var/log/puppet/masterhttp.log
agent:
puppet agent --test --server master.domain.com

master:

puppet cert list
puppet cert list -all
puppet cert sign agent.domain.com



#######
mkdir -p /etc/puppet/modules/base/{files,manifests,templates,lib,tests,spec}
mkdir -p /etc/puppet/modules/base/files/test
mkdir  /etc/puppet/manifests/nodes
cat >> /etc/puppet/modules/base/manifests/touch.pp <<EOF
#touch.pp for puppet
class base::touch {
    file { "/usr/local/src/passwd":
        backup => ".bak_$uptime_seconds",
        ensure => present,
        group => nobody,
        owner => nobody,
        mode => 600,
        content => "hello world!!",
    }
}
EOF

cat >> /etc/puppet/modules/base/manifests/init.pp<<EOF
#base module init.pp for puppet
class base {
    include base::touch
}
EOF

cat >> /etc/puppet/manifests/nodes/agent.domain.com.pp<<EOF
#base nodes db1.pp for puppet
node 'agent.domain.com' {
    include base
}
EOF


cat >> /etc/puppet/manifests/modules.pp <<EOF
import "base"
EOF

cat >> /etc/puppet/manifests/site.pp <<EOF
import "modules.pp"
import "nodes/*.pp"
EOF

cat >> /etc/puppet/modules/base/manifests/sync.pp <<EOF
class base::sync {
    file { "/usr/local/src/test":
        ensure  => directory,
        source  => "puppet:///modules/base/test/",
        ignore  => '*log*',
        recurse => true,
#purge   => true,
#force   => true,
    }
}
EOF


vim /etc/puppet/modules/base/manifests/init.pp

class base {
include base::touch,base::sync
}

服务器端验证
puppet parser validate /etc/puppet/modules/base/manifests/init.pp

客户端测试
puppetd  agent  --test



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





